import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
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

  void _loadData() async{
    final Uri url = Uri.https('shopapp-56012-default-rtdb.firebaseio.com','shopping_list.json');
    final http.Response response = await http.get(url);
    final Map<String,dynamic> loadedData = json.decode(response.body);

    final List<GroceryItem> _loadedItems = [];

    for(var item in loadedData.entries){
      final GroceryCategory category = categories.entries.firstWhere(
          (_element) => _element.value.title == item.value['category'],
      ).value;
      _loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category
        )
      );
      setState(() {
        _groceryItems=_loadedItems;
      });
    }

    log(response.body.toString());
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

    if (_groceryItems . isNotEmpty){
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context,index)=>Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (_){
            setState(() {
              _groceryItems.remove(_groceryItems[index]);
            });
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
    await Navigator.push<GroceryItem>(
        context,
        MaterialPageRoute(
            builder: (context) => NewItem()
        )
    );
    _loadData();
  }
}

