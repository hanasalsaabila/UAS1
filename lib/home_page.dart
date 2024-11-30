import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import DatabaseHelper
import 'cart_page.dart';
import 'product_detail.dart'; // Import ProductDetail
import 'models/product.dart'; // Import Product
import 'wishlist_page.dart';
import 'cart.dart'; // Import Cart dengan benar
import 'order_history.dart'; // Import OrderHistoryPage

class HomePage extends StatefulWidget {
  final Cart cart;

  const HomePage({Key? key, required this.cart}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Inisialisasi DatabaseHelper
  String selectedCategory = 'All';
  List<Product> _wishlist = [];
  List<Product> _allProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchWishlist();
  }

  Future<void> fetchProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Product> products = await _databaseHelper.getProducts();
      products = products.where((product) {
        return ['SEVENTEEN', 'NCT', 'RIIZE', 'ATEEZ'].contains(product.category);
      }).toList();

      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data produk: $e')),
      );
    }
  }

  Future<void> fetchWishlist() async {
    try {
      List<Product> wishlist = await _databaseHelper.getWishlist();
      setState(() {
        _wishlist = wishlist;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil wishlist: $e')),
      );
    }
  }

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') {
      return _allProducts;
    } else {
      return _allProducts.where((product) => product.category == selectedCategory).toList();
    }
  }

  void toggleWishlist(Product product) async {
    if (_wishlist.contains(product)) {
      await _databaseHelper.removeFromWishlist(product.id!);
      setState(() {
        _wishlist.remove(product);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} dihapus dari wishlist')),
      );
    } else {
      await _databaseHelper.addToWishlist(product.id!);
      setState(() {
        _wishlist.add(product);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} ditambahkan ke wishlist')),
      );
    }
  }

  void addToCart(Product product) {
    widget.cart.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} telah ditambahkan ke keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildCategoryHeader(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'List Produk',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildProductGrid(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'VibeMerch',
        style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(cart: widget.cart),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WishlistPage(cart: widget.cart),
              ),
            ).then((_) => fetchWishlist());
          },
        ),
        IconButton(
          icon: const Icon(Icons.history, color: Colors.black), // Ikon riwayat pesanan
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistoryPage(), // Halaman riwayat pesanan
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey, Colors.grey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Kategori',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildCategoryDropdown(),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButton<String>(
      value: selectedCategory,
      dropdownColor: Colors.blueGrey,
      underline: Container(),
      iconEnabledColor: Colors.white,
      isExpanded: true,
      style: const TextStyle(color: Colors.white),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue ?? 'All';
        });
      },
      items: ['All', 'SEVENTEEN', 'NCT', 'ATEEZ', 'RIIZE']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductGrid() {
    return Expanded(
      child: filteredProducts.isEmpty
          ? const Center(
        child: Text(
          "Tidak ada produk yang sesuai.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return _buildProductCard(product);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              product: product,
              cart: widget.cart,
            ),
          ),
        ).then((_) => fetchProducts());
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Rp ${product.price}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.blueGrey),
                  onPressed: () {
                    addToCart(product);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          product: product,
                          cart: widget.cart,
                        ),
                      ),
                    );
                  },
                  child: const Text('Beli', style: TextStyle(color: Colors.white)),
                ),
                IconButton(
                  icon: Icon(
                    _wishlist.contains(product) ? Icons.favorite : Icons.favorite_border,
                    color: _wishlist.contains(product) ? Colors.red : Colors.blueGrey,
                  ),
                  onPressed: () {
                    toggleWishlist(product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
