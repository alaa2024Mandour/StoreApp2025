import 'package:shop_app/models/category.dart' show GroceryCategory;

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final GroceryCategory  category;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category
  });

}