import 'package:flutter/material.dart';
import 'models/product.dart';
import 'cart.dart';
import 'database_helper.dart';

class WishlistPage extends StatefulWidget {
  final Cart cart;

  const WishlistPage({Key? key, required this.cart}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Product> _wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      final wishlist = await _databaseHelper.getWishlist();
      setState(() {
        _wishlist = wishlist;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat wishlist: $e')),
      );
    }
  }

  Future<void> _removeFromWishlist(Product product) async {
    try {
      await _databaseHelper.removeFromWishlist(product.id!);
      _loadWishlist();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} dihapus dari wishlist')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus dari wishlist: $e')),
      );
    }
  }

  void _addToCart(Product product) {
    widget.cart.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} telah ditambahkan ke keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: _wishlist.isEmpty
          ? const Center(child: Text("Wishlist kosong"))
          : ListView.builder(
        itemCount: _wishlist.length,
        itemBuilder: (context, index) {
          final product = _wishlist[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: product.imageUrl.startsWith('http')
                  ? Image.network(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              )
                  : Image.asset(
                product.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
              title: Text(
                product.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Rp ${product.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => _addToCart(product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeFromWishlist(product),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
