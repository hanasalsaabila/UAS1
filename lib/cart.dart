import 'models/product.dart';

class Cart {
  final List<Product> _cartItems = [];

  // Getter untuk item keranjang
  List<Product> get cartItems => List.unmodifiable(_cartItems); // Return unmodifiable list untuk keamanan data

  // Tambahkan produk ke keranjang
  void addToCart(Product product) {
    // Cek apakah produk sudah ada di keranjang
    final existingProduct = _cartItems.firstWhere(
          (item) => item.id == product.id,
      orElse: () => Product(
        id: null,
        title: '',
        price: 0,
        imageUrl: '',
        description: '',
        category: '',
        quantity: 0,
      ),
    );

    if (existingProduct.id != null) {
      // Jika produk sudah ada, tambahkan kuantitasnya
      existingProduct.quantity += 1;
    } else {
      // Jika produk belum ada, tambahkan ke keranjang dengan kuantitas awal 1
      product.quantity = 1;
      _cartItems.add(product);
    }
  }

  // Hapus produk dari keranjang
  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.id == product.id);
  }

  // Kurangi kuantitas produk di keranjang
  void decrementQuantity(Product product) {
    final existingProduct = _cartItems.firstWhere(
          (item) => item.id == product.id,
      orElse: () => Product(
        id: null,
        title: '',
        price: 0,
        imageUrl: '',
        description: '',
        category: '',
        quantity: 0,
      ),
    );

    if (existingProduct.id != null) {
      if (existingProduct.quantity > 1) {
        existingProduct.quantity -= 1;
      } else {
        // Jika kuantitas mencapai 0, hapus produk dari keranjang
        removeFromCart(product);
      }
    }
  }

  // Kosongkan keranjang
  void clearCart() {
    _cartItems.clear();
  }

  // Hitung total harga dari semua item di keranjang
  double getTotalAmount() {
    return _cartItems.fold(
      0.0,
          (total, item) => total + (item.price * item.quantity),
    );
  }

  // Hitung jumlah total item di keranjang
  int getTotalItems() {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  // Perbarui kuantitas produk
  void updateQuantity(Product product, int newQuantity) {
    final existingProduct = _cartItems.firstWhere(
          (item) => item.id == product.id,
      orElse: () => Product(
        id: null,
        title: '',
        price: 0,
        imageUrl: '',
        description: '',
        category: '',
        quantity: 0,
      ),
    );

    if (existingProduct.id != null) {
      if (newQuantity > 0) {
        existingProduct.quantity = newQuantity;
      } else {
        // Jika kuantitas mencapai 0, hapus produk dari keranjang
        removeFromCart(product);
      }
    }
  }
}
