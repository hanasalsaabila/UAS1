class Product {
  final String title;
  final int price;
  final String imageUrl;
  final String description;
  final String category;
  int quantity;

  Product({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.quantity = 1,  // Default quantity
  });
}