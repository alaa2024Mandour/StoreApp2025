import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';

import '../models/category.dart';

class NewItem extends StatefulWidget {
   NewItem({super.key});

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
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          log(enteredName);
                          log(enteredQuantity.toString());
                          log(selectedCategory.toString());
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
