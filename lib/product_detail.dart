import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'database_helper.dart';
import 'models/product.dart';
import 'cart.dart';
import 'order_review_page.dart'; // Import OrderReviewPage

class ProductDetail extends StatefulWidget {
  final Product product;
  final Cart cart;

  const ProductDetail({Key? key, required this.product, required this.cart}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<double> getAverageRating(int productId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT AVG(rating) AS average_rating
      FROM ratings
      WHERE product_id = ?
    ''', [productId]);

    return result.isNotEmpty ? (result[0]['average_rating'] as double) : 0.0;
  }

  void _goToOrderReviewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderReviewPage(
          products: [widget.product],
          quantities: [1], // Kuantitas default 1
          cart: widget.cart,
          shouldClearCart: false,
          isDirectPurchase: true, // Indikasi pembelian langsung
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 175,
                        height: 175,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Center(
                              child: Image.asset(
                                widget.product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rp${widget.product.price}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      FutureBuilder<double>(
                        future: getAverageRating(widget.product.id!),
                        builder: (context, snapshot) {
                          return RatingBarIndicator(
                            rating: snapshot.data ?? 0,
                            itemCount: 5,
                            itemSize: 19,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "In Stock: ${widget.product.quantity} items",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.cart.addToCart(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.product.title} telah ditambahkan ke keranjang'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Tambah ke Keranjang',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToOrderReviewPage, // Navigasi ke OrderReviewPage
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
