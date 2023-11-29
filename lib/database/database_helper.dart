import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project2/database/model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const _databaseName = 'ProductDb.db';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDir = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDir.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateTable);
  }

  _onCreateTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Product.tableName} (
        ${Product.colName} TEXT PRIMARY KEY,
        ${Product.colDescription} TEXT NOT NULL,
        ${Product.colPrice} NUMERIC NOT NULL,
        ${Product.coltime} ,
        ${Product.colFavorite} INTEGER NOT NULL
      )
   ''');
  }

  // Insert
  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert(
      Product.tableName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // update
  Future<int> updateProduct(Product product) async {
    Database db = await database;
    return await db.update(Product.tableName, product.toMap(),
        where: '${Product.colName}=?', whereArgs: [product.name]);
  }

  // delete
  Future<int> deleteProduct(String name) async {
    Database db = await database;
    return await db.delete(Product.tableName,
        where: '${Product.colName}=?', whereArgs: [name]);
  }

  Future<List<Product>> fetchProducts() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Product.tableName);
    if (maps.isEmpty) {
      return [];
    } else {
      return List.generate(maps.length, (index) {
        return Product(
          name: maps[index][Product.colName],
          description: maps[index][Product.colDescription],
          price: maps[index][Product.colPrice] + 0.00,
          time: maps[index][Product.coltime],
          favorite: maps[index][Product.colFavorite],
        );
      });
    }
  }
}
