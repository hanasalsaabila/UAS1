import 'package:flutter/material.dart';
import 'login_page.dart'; // Import LoginPage
import 'cart.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();

  try {
    // Hapus database lama
    print("Menghapus database lama...");
    await dbHelper.deleteOldDatabase();

    // Inisialisasi database baru
    print("Inisialisasi database baru...");
    await dbHelper.database;

    print("Database berhasil diinisialisasi. Menjalankan aplikasi...");
  } catch (e) {
    print("Error saat menginisialisasi database: $e");
  }

  // Jalankan aplikasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Cart cart = Cart(); // Inisialisasi cart

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeMerch',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false, // Menyembunyikan banner "debug"
      home: LoginPage(cart: cart), // LoginPage sebagai halaman awal
    );
  }
}
