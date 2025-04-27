import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';

class NewItem extends StatelessWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a new item'),),
      body: Form(
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
                    validator: (value){
                      if(value == null || value.isEmpty ){
                        return 'must be not empty';
                      }
                      return null;
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
                          onChanged: (value){

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
                      onPressed: (){},
                      child: Text("Reset")
                  ),

                  ElevatedButton(
                      onPressed: (){},
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
