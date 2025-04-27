import 'package:flutter/material.dart';
import 'package:shop_app/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 146, 230, 247),
            surface:  const Color.fromARGB(255, 44, 50, 60),
          brightness: Brightness.dark
        ),
        scaffoldBackgroundColor:const Color.fromARGB(255, 49, 57, 59),
        useMaterial3: true
      ),
      home: const GroceryList(),
    );
  }
}


