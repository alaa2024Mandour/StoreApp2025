import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/models/grocery_items.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
   const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
   var enteredName = '';
   int enteredQuantity = 1;
   GroceryCategory? selectedCategory = categories[Categories.dairy];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a new item'),),
      body: Form(
        key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name'
                ),
                validator: (value){
                  if(value == null || value.isEmpty || value.length <= 1 || value.length > 50){
                    return 'must be between 1 and 50 ';
                  }
                  return null;
                },
                onSaved: (value){
                  enteredName = value!;
                },
                maxLength: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Quantity'
                    ),
                    validator: (String ? value){
                      if(int.tryParse(value!) == null || int.tryParse(value)!<=0 ){
                        return 'must be valid , positive number';
                      }
                      return null;
                    },
                      onSaved: (value){
                      enteredQuantity = int.tryParse(value!)!;
                      },
                      keyboardType: TextInputType.number,
                  ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                      child: DropdownButtonFormField(
                          items: [
                            for(final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        height:24 ,
                                        width: 24,
                                        color: category.value.color,
                                      ),
                                      Text(category.value.title),
                                    ],
                                  ),
                              )
                          ],
                          value: selectedCategory,
                          onChanged: (GroceryCategory? value){
                              setState(() {
                                selectedCategory = value!;
                              });
                          }
                      )
                  )
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){
                        _formKey.currentState!.reset();
                      },
                      child: Text("Reset")
                  ),

                  ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          final url = Uri.https('shopapp-56012-default-rtdb.firebaseio.com','shopping_list.json');
                          final http.Response response =  await http.post(
                              url,
                            headers: {
                                'Content-Type':'application/json'
                            },
                            body:json.encode({
                                'name':enteredName,
                              'quantity':enteredQuantity,
                              'category':selectedCategory?.title
                            })
                          );
                          if(response.statusCode == 200){
                            log(response.body);
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: Text("Add Item")
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
