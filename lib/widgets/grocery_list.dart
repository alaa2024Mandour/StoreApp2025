import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/grocery_items.dart';
import 'package:shop_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
    String? error;

  void _loadData() async{
    final Uri url = Uri.https('shopapp-56012-default-rtdb.firebaseio.com','shopping_list.json');
    final http.Response response = await http.get(url).catchError((onError){
      return http.Response('', 400);
    });

    if (response.statusCode >= 400){
      setState(() {
        error = 'Failed to fetch data. please tray again later';
      });
      return;
    }

    if(response.body == 'null'){
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String,dynamic> loadedData = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];

    for(var item in loadedData.entries){
      final GroceryCategory category = categories.entries.firstWhere(
          (element) => element.value.title == item.value['category'],
      ).value;
      loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category
        )
      );
      setState(() {
        _groceryItems=loadedItems;
        _isLoading = false;
      });
    }

    log(response.body.toString());
  }
  bool _isLoading =true;

  void _removeItem(GroceryItem item)async{
    final index =_groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final Uri url = Uri.https('shopapp-56012-default-rtdb.firebaseio.com','shopping_list/${item.id}.json');
    final http.Response response = await http.delete(url);
   if(response.statusCode >= 400){
     ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('we could not delete the item'))
     );
     setState(() {
       _groceryItems.insert(index,item);
     });
   }
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context){
    Widget  content = Center(
      child: Text("No Item added yet"),
    );

    if (_isLoading){
      content = Center(child: CircularProgressIndicator(),);
    }
    if (_groceryItems . isNotEmpty){
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context,index)=>Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (_){
             _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }
    if(error != null){
      content = Center(
        child: Text(error!),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Grocery'),
        actions: [
          IconButton(
              onPressed: addItem,
              icon: Icon(Icons.add)
          )
        ],
      ),
      body:content
    );
  }

  void addItem() async{
    final newItem = await Navigator.push<GroceryItem>(
        context,
        MaterialPageRoute(
            builder: (context) => NewItem()
        )
    );

    if(newItem == null){
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
    // _loadData();
  }
}

