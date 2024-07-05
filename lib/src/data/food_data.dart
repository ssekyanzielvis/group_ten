class Food {
  final String id;
  final String name;
  final String imagePath;
  final String category;
  final double price;
  final double discount;
  final double ratings;

  Food({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.price,
    required this.discount,
    required this.ratings,
  });
}

final foods = [
  Food(
    id: '1',
    name: 'Ice cream',
    imagePath: 'lib/assets/images/all favourites ice cream.jfif',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '2',
    name: 'FriedBeef',
    imagePath: 'lib/assets/images/pilau+beef.jpg',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '3',
    name: 'Sausage',
    imagePath: 'lib/assets/images/sausage breakfast.jpg',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '4',
    name: 'Youghut',
    imagePath: 'lib/assets/images/youghut tinned.jfif',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '5',
    name: 'EggRoll',
    imagePath: 'lib/assets/images/EggRoll.jpg',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '6',
    name: 'Chapati',
    imagePath: 'lib/assets/images/chapatifestival.jpg',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '7',
    name: 'Rolex',
    imagePath: 'lib/assets/images/rolex.jfif',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '8',
    name: 'Pilau+Chicken',
    imagePath: 'lib/assets/images/pilau beef lusania.jpg',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
  Food(
    id: '9',
    name: 'Chips+Chicken',
    imagePath: 'lib/assets/images/chips+chicken.jpg',
    category: '1',
    price: 100.0,
    discount: 7.0,
    ratings: 94.0,
  ),
];
