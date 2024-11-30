// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'your_database_name.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create your database tables here
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        price INTEGER,
        image_url TEXT,
        description TEXT,
        category TEXT,
        quantity INTEGER
      )
    ''');
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        title: maps[i]['title'],
        price: maps[i]['price'],
        imageUrl: maps[i]['image_url'],
        description: maps[i]['description'],
        category: maps[i]['category'],
        quantity: maps[i]['quantity'],
      );
    });
  }

  Future<void> insertProduct(Map<String, dynamic> productData) async {
    final db = await database;
    await db.insert('products', productData);
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}