import 'dart:ui';


class GroceryCategory {
final String title;
final Color color ;

const GroceryCategory (this.title, this.color);

}

enum Categories  {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}