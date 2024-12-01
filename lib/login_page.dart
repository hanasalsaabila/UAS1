import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cart.dart';
import 'database_helper.dart'; // Import helper

class LoginPage extends StatefulWidget {
  final Cart cart;

  const LoginPage({Key? key, required this.cart}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginMode = true; // Untuk menentukan mode Login atau Registrasi
  bool _isLoading = false;

  // Fungsi untuk validasi username dan password saat login
  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Ambil username dan password dari controller
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Cek ke database apakah username dan password valid
    bool isValidUser = await DatabaseHelper().validateUser(username, password);

    setState(() {
      _isLoading = false;
    });

    if (isValidUser) {
      // Jika valid, navigasi ke halaman HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(cart: widget.cart),
        ),
      );
    } else {
      // Jika tidak valid, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi untuk registrasi pengguna baru
  void _register() async {
    setState(() {
      _isLoading = true;
    });

    // Ambil username dan password dari controller
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Simpan user baru ke database
    bool isRegistered = await DatabaseHelper().registerUser(username, password);

    setState(() {
      _isLoading = false;
    });

    if (isRegistered) {
      // Jika registrasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil, silakan login'),
          backgroundColor: Colors.green,
        ),
      );
      // Beralih ke mode login setelah registrasi berhasil
      setState(() {
        _isLoginMode = true;
      });
    } else {
      // Jika gagal, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username sudah terdaftar atau terjadi kesalahan!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'VibeMerch',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : (_isLoginMode ? _login : _register),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    _isLoginMode ? 'Login' : 'Daftar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode; // Beralih mode antara Login dan Registrasi
                    });
                  },
                  child: Text(
                    _isLoginMode
                        ? 'Belum punya akun? Daftar di sini'
                        : 'Sudah punya akun? Login di sini',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur "Lupa Password" belum tersedia'),
                        backgroundColor: Colors.blueGrey,
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
