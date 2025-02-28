class Vegetable {
  final String name;
  final String image;
  final String price;

  const Vegetable({
    required this.name,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
    };
  }

  factory Vegetable.fromMap(Map<String, dynamic> data) {
    return Vegetable(
      name: data['name'] ?? '',
      price: data['price'] ?? '', // Keeping it as int
      image: data['image'] ?? '',
    );
  }
}
