import 'package:flutter/material.dart';
import 'models/product.dart';
import 'payment_success_page.dart';
import 'cart.dart';
import 'order_history.dart';

class OrderReviewPage extends StatefulWidget {
  final List<Product> products;
  final List<int> quantities;
  final Cart cart;
  final bool shouldClearCart;
  final bool isDirectPurchase;

  const OrderReviewPage({
    Key? key,
    required this.products,
    required this.quantities,
    required this.cart,
    required this.shouldClearCart,
    required this.isDirectPurchase,
  }) : super(key: key);

  @override
  _OrderReviewPageState createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  String _selectedPaymentMethod = 'Master Card';
  String _shippingAddress =
      'Taimoor Sikander, +923329121290, Muhallah Usman a bad, Chakwal, Punjab 48800, Pakistan';

  final List<String> _paymentMethods = ['Master Card', 'BCA', 'BNI', 'SPAY', 'OVO', 'MANDIRI'];
  final List<String> _addresses = [
    'Taimoor Sikander, +923329121290, Muhallah Usman a bad, Chakwal, Punjab 48800, Pakistan',
    '123 Main Street, Jakarta, Indonesia',
    '456 Second Street, Bandung, Indonesia'
  ];

  @override
  Widget build(BuildContext context) {
    final double shippingFee = 5000.0;
    final double subtotal = _calculateSubtotal();
    final double tax = subtotal * 0.1; // 10% tax
    final double total = subtotal + shippingFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Review', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Produk yang dibeli
              ...List.generate(widget.products.length, (index) {
                final product = widget.products[index];
                final quantity = widget.quantities[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Hero(
                      tag: product.title,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      'Qty: $quantity',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      'Rp ${(product.price * quantity).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
              const Divider(),

              // Total harga
              _buildPriceSummary(subtotal, shippingFee, tax, total),

              const SizedBox(height: 20),

              // Payment Method
              _buildPaymentMethodSelector(context),

              // Shipping Address
              _buildShippingAddressSelector(context),

              const Spacer(),

              // Checkout Button
              _buildCheckoutButton(context, total),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary(double subtotal, double shippingFee, double tax, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          trailing: Text('Rp ${subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18)),
        ),
        ListTile(
          title: const Text('Shipping Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          trailing: Text('Rp ${shippingFee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18)),
        ),
        ListTile(
          title: const Text('Tax Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          trailing: Text('Rp ${tax.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18)),
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          trailing: Text(
            'Rp ${total.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        GestureDetector(
          onTap: () => _selectPaymentMethod(context),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.blueAccent, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedPaymentMethod,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingAddressSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Address',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        GestureDetector(
          onTap: () => _selectShippingAddress(context),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.redAccent, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _shippingAddress,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, double total) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(15),
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessPage(
                cart: widget.cart,
                shouldClearCart: widget.shouldClearCart,
                products: widget.products,
                quantities: widget.quantities,
                totalAmount: total,
              ),
            ),
          );
        },
        child: Text(
          'Checkout Rp ${total.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  double _calculateSubtotal() {
    double subtotal = 0.0;
    for (int i = 0; i < widget.products.length; i++) {
      subtotal += widget.products[i].price * widget.quantities[i];
    }
    return subtotal;
  }

  void _selectPaymentMethod(BuildContext context) async {
    final selectedMethod = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ..._paymentMethods.map((String method) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, method);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card, color: Colors.blueAccent, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              method,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (_selectedPaymentMethod == method)
                            const Icon(Icons.check_circle, color: Colors.green, size: 24),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );

    if (selectedMethod != null && selectedMethod != _selectedPaymentMethod) {
      setState(() {
        _selectedPaymentMethod = selectedMethod;
      });
    }
  }

  void _selectShippingAddress(BuildContext context) async {
    final selectedAddress = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Shipping Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ..._addresses.map((String address) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, address);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (_shippingAddress == address)
                            const Icon(Icons.check_circle, color: Colors.green, size: 24),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );

    if (selectedAddress != null && selectedAddress != _shippingAddress) {
      setState(() {
        _shippingAddress = selectedAddress;
      });
    }
  }
}
