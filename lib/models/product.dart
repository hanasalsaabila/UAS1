// lib/models/product.dart
class Product {
  final int? id; // Nullable untuk produk baru
  final String title;
  final int price;
  final String imageUrl;
  final String description;
  final String category;
  int quantity;
  double averageRating;  // Menambahkan averageRating

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.quantity = 1,
    this.averageRating = 0.0, // Default value untuk rata-rata rating
  });

  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Sertakan id jika ada
      'title': title,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'category': category,
      'quantity': quantity,
      'average_rating': averageRating, // Menambahkan average_rating ke Map
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      imageUrl: map['image_url'],
      description: map['description'],
      category: map['category'],
      quantity: map['quantity'],
      averageRating: map['average_rating'] ?? 0.0,  // Menambahkan average_rating
    );
  }

  // Override equality dan hashcode agar bisa dibandingkan dalam list
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
