import 'package:flutter/material.dart';
import 'package:shop_app/data/dummy_items.dart';
import 'package:shop_app/widgets/new_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Grocery'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewItem()
                    )
                );
              },
              icon: Icon(Icons.add)
          )

        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
          itemBuilder: (context,index)=>ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              height: 24,
              width: 24,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(groceryItems[index].quantity.toString()),
          ),

      ),
    );
  }
}
