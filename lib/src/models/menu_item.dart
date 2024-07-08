class MenuItem {
  String id;
  String name;
  double price;
  String imageUrl;

  MenuItem(
      {required this.id,
      required this.name,
      required this.price,
      this.imageUrl = ''});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  static MenuItem fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
