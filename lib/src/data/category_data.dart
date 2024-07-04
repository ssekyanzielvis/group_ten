//import 'package:flutter/foundation.dart';

//import '../models/category_model.dart';

class Category {
  final int numberOfItems;
  final String imagePath;
  final String categoryName;

  Category(
      {required this.numberOfItems,
      required this.imagePath,
      required this.categoryName});
}

final categories = [
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/burger.jpg",
    categoryName: "burger",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/posho+fish.jpg",
    categoryName: "Posho & Fish",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/vegetable chicken.jpg",
    categoryName: "Vegetables++",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/vegetable noodles.jpg",
    categoryName: "Noodles",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/snacks.jpg",
    categoryName: "Snacks",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/youghut.jfif",
    categoryName: "Yoghurt",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/rolex.jfif",
    categoryName: "Rolex",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/paste gnuts.jfif",
    categoryName: "Groundnuts Paste",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/pilau beef lusania.jpg",
    categoryName: "Roasted Beef",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/chips+fish.jfif",
    categoryName: "Fish & Chips",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/casava chips.jpg",
    categoryName: "Cassava Chips",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/pineapple juice.jfif",
    categoryName: "Soft Drinks",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/sausagevip.jpg",
    categoryName: "Sausage",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/pizza combo.jpg",
    categoryName: "Pizza",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/pilau+fish.jpg",
    categoryName: "Pilau",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/chicken favourite.jpg",
    categoryName: "Chicken",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/chips chicken salads.jfif",
    categoryName: "Chips",
  ),
  Category(
    numberOfItems: 5,
    imagePath: "lib/assets/images/chapati.jfif",
    categoryName: "Chapati",
  ),
];
