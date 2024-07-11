import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JSON/users.dart';
import '../models/article.dart'; // Import Article
import '../models/stock.dart'; // Import Stock

class DatabaseHelper {
  final String _databaseName = "auth_inventory.db"; // Unified database name
  static Database? _db;
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  // Tables
  String _userTable = '''
  CREATE TABLE users (
    usrId INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT,
    email TEXT,
    usrName TEXT UNIQUE,
    usrPassword TEXT
  )
  ''';

  String _articleTable = '''
  CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Ref_article TEXT NOT NULL,
    Designation_article TEXT NOT NULL
  )
  ''';

  String _stockTable = '''
  CREATE TABLE stock (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dateStock TEXT NOT NULL,
    article INTEGER,
    quantite INTEGER,
    FOREIGN KEY (article) REFERENCES articles (id)
  )
  ''';

  DatabaseHelper._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute(_userTable);
      await db.execute(_articleTable);
      await db.execute(_stockTable);
    });
  }

  // Authentication Methods
  Future<bool> authenticate(Users usr) async {
    final db = await database;
    var result = await db.rawQuery(
        "select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    return result.isNotEmpty;
  }

  Future<int> createUser(Users usr) async {
    final db = await database;
    return db.insert("users", usr.toMap());
  }

  Future<Users?> getUser(String usrName) async {
    final db = await database;
    var res =
        await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  // Inventory Methods
  Future<int> insertArticle(Article article) async {
    final db = await database;
    return db.insert("articles", article.toMap());
  }

  Future<List<Article>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("articles");
    return List.generate(maps.length, (i) {
      return Article.fromMap(maps[i]);
    });
  }

  Future<int> updateArticle(Article article) async {
    final db = await database;
    return await db.update(
      "articles",
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  Future<int> deleteArticle(int id) async {
    final db = await database;
    return await db.delete("articles", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return db.insert(
      "stock",
      {
        'dateStock': stock.dateStock.toIso8601String(),
        'article': stock.article.id,
        'quantite': stock.quantite,
      },
    );
  }

  // Add CRUD methods for Stock if needed (e.g., getStock, updateStock, deleteStock)
}
