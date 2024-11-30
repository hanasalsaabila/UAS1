import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Getter untuk database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kpop_store.db');

    print("Database path: $path"); // Log untuk debugging

    return await openDatabase(
      path,
      version: 3, // Perbarui versi jika ada perubahan skema
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Membuat tabel saat database pertama kali dibuat
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        price INTEGER NOT NULL,
        image_url TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER DEFAULT 1,
        average_rating REAL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ratings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        rating INTEGER,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_price INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price INTEGER NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    await _insertInitialData(db);
  }

  // Untuk perubahan skema database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE wishlist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          FOREIGN KEY (product_id) REFERENCES products (id)
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          total_price INTEGER NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE order_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          order_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          FOREIGN KEY (order_id) REFERENCES orders (id),
          FOREIGN KEY (product_id) REFERENCES products (id)
        )
      ''');
    }
  }

  // Menambahkan data awal ke tabel produk
  Future<void> _insertInitialData(Database db) async {
    List<Map<String, dynamic>> initialProducts = [
      {
        'title': 'Post Card',
        'price': 200000,
        'image_url': 'assets/images.png',
        'description': 'babibu.',
        'category': 'SEVENTEEN',
        'quantity': 1,
        'average_rating': 0,
      },
      {
        'title': 'Carat Ly',
        'price': 200000,
        'image_url': 'assets/img_4.png',
        'description': 'babibu.',
        'category': 'SEVENTEEN',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'Album Walk',
        'price': 200000,
        'image_url': 'assets/img_7.png',
        'description': 'babibu.',
        'category': 'NCT',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'Badge set',
        'price': 200000,
        'image_url': 'assets/svt1.png',
        'description': 'babibu.',
        'category': 'SEVENTEEN',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': '[DREAMSCAPE]',
        'price': 340000,
        'image_url': 'assets/nct2.png',
        'description': '[DREAMSCAPE] (Vertical Flip Ver.) (Random).',
        'category': 'NCT',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'Winter Special Album',
        'price': 340000,
        'image_url': 'assets/nct21.png',
        'description': 'Winter Special Mini Album Candy (Digipack Ver.) Random',
        'category': 'NCT',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'Winter Special Mini Album',
        'price': 330000,
        'image_url': 'assets/rizze3.png',
        'description': '[RIIZING : Epilogue]',
        'category': 'RIIZE',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'SANCTUARY',
        'price': 10800,
        'image_url': 'assets/ate1.png',
        'description': 'The Star Chapter: SANCTUARY (Weverse Albums ver.) (Random)',
        'category': 'ATEEZ',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'SANCTUARY LOVER',
        'price': 10800,
        'image_url': 'assets/ate2.png',
        'description': 'The Star Chapter: SANCTUARY (Random)',
        'category': 'ATEEZ',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'LEveL',
        'price': 10800,
        'image_url': 'assets/ate3.png',
        'description': 'LEveL (Limited Edition)',
        'category': 'ATEEZ',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
      {
        'title': 'minisode 3',
        'price': 10800,
        'image_url': 'assets/ate4.png',
        'description': 'minisode 3: TOMORROW (Weverse Albums ver.) (Random)',
        'category': 'ATEEZ',
        'quantity': 1,
        'average_rating': 0, // Rata-rata rating awal
      },
    ];

    for (var product in initialProducts) {
      await db.insert('products', product);
    }
  }

  // Fungsi untuk menghapus database lama
  Future<void> deleteOldDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'kpop_store.db');
      await deleteDatabase(path);
      print("Database lama berhasil dihapus.");
    } catch (e) {
      print("Error saat menghapus database lama: $e");
    }
  }

  // Fungsi untuk rating
  Future<void> addRating(int productId, int rating) async {
    final db = await database;

    await db.insert('ratings', {
      'product_id': productId,
      'rating': rating,
    });

    final result = await db.rawQuery('''
      SELECT AVG(rating) AS average_rating
      FROM ratings
      WHERE product_id = ?
    ''', [productId]);

    double averageRating = result[0]['average_rating'] != null
        ? (result[0]['average_rating'] as double)
        : 0.0;

    await db.update(
      'products',
      {'average_rating': averageRating},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // Fungsi wishlist
  Future<void> addToWishlist(int productId) async {
    final db = await database;
    await db.insert('wishlist', {'product_id': productId});
  }

  Future<void> removeFromWishlist(int productId) async {
    final db = await database;
    await db.delete('wishlist', where: 'product_id = ?', whereArgs: [productId]);
  }

  Future<List<Product>> getWishlist() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.*
      FROM products p
      INNER JOIN wishlist w ON p.id = w.product_id
    ''');

    return result.map((item) => Product.fromMap(item)).toList();
  }

  // Fungsi produk
  Future<List<Product>> getProducts() async {
    final db = await database;
    final result = await db.query('products');
    return result.map((item) => Product.fromMap(item)).toList();
  }

  Future<Product?> getProduct(int productId) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<void> insertProduct(Map<String, dynamic> productData) async {
    final db = await database;
    await db.insert('products', productData);
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateProduct(Map<String, dynamic> productMap) async {
    final db = await database;
    await db.update(
      'products',
      productMap,
      where: 'id = ?',
      whereArgs: [productMap['id']],
    );
  }

  // Fungsi pesanan
  Future<void> createOrder(int totalPrice, List<Product> products) async {
    final db = await database;

    int orderId = await db.insert('orders', {
      'total_price': totalPrice,
      'created_at': DateTime.now().toIso8601String(),
    });

    for (var product in products) {
      await db.insert('order_items', {
        'order_id': orderId,
        'product_id': product.id,
        'quantity': product.quantity,
        'price': product.price,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT o.id, o.total_price, o.created_at, 
             oi.product_id, oi.quantity, oi.price, 
             p.title, p.image_url
      FROM orders o
      INNER JOIN order_items oi ON o.id = oi.order_id
      INNER JOIN products p ON oi.product_id = p.id
      ORDER BY o.created_at DESC
    ''');
  }
}
