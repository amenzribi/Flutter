/** 
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JSON/users.dart';
import '../models/article.dart'; // Import Article
import '../models/stock.dart'; // Import Stock
import '../models/entete.dart';

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
    Designation_article TEXT NOT NULL,
    Code_a_barres INTEGER   
  )
  ''';
  String _enteteTable = '''
  CREATE TABLE entete (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dateEntete TEXT NOT NULL,
    description TEXT NOT NULL
  )
  ''';

  String _stockTable = '''
  CREATE TABLE stock (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dateStock TEXT NOT NULL,
    article INTEGER,
    entete INTEGER, 
    quantite INTEGER,
    FOREIGN KEY (article) REFERENCES articles (id),
    FOREIGN KEY (entete) REFERENCES entete (id)
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

    return openDatabase(path, version: 4, onCreate: (db, version) async {
      await db.execute(_userTable);
      await db.execute(_articleTable);
      await db.execute(_enteteTable);
      await db.execute(_stockTable);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      // Migration: add the Code_a_barres column
      if (oldVersion < 3) {
        // Provide a default value (e.g., 0)
        await db
            .execute('ALTER TABLE articles ADD COLUMN Code_a_barres INTEGER ');
      }

      // Migration for 'entete' table
      if (oldVersion < 4) {
        await db.execute(_enteteTable);
        await db.execute(
            'ALTER TABLE stock ADD COLUMN entete INTEGER REFERENCES entete(id)'); // Add entete column to stock table
      }
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

    // Create the map for the update, only including non-null or non-empty values
    final updateData = <String, dynamic>{};
    if (article.refArticle.isNotEmpty) {
      updateData['Ref_article'] = article.refArticle;
    }
    if (article.designationArticle.isNotEmpty) {
      updateData['Designation_article'] = article.designationArticle;
    }
    if (article.codeABarres != null) {
      updateData['Code_a_barres'] = article.codeABarres;
    }

    // Perform the update if there are any values to update
    if (updateData.isNotEmpty) {
      return await db.update(
        "articles",
        updateData,
        where: 'id = ?',
        whereArgs: [article.id],
      );
    } else {
      return 0; // No changes were made
    }
  }

  Future<int> deleteArticle(int id) async {
    final db = await database;
    return await db.delete("articles", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertEntete(Entete entete) async {
    final db = await database;
    return db.insert("entete", entete.toMap());
  }

  Future<List<Entete>> getEntetes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("entete");
    return List.generate(maps.length, (i) {
      return Entete.fromMap(maps[i]);
    });
  }

  Future<int> updateEntete(Entete entete) async {
    final db = await database;
    return db.update(
      "entete",
      entete.toMap(),
      where: 'id = ?',
      whereArgs: [entete.id],
    );
  }

  Future<int> deleteEntete(int id) async {
    final db = await database;
    return await db.delete("entete", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return db.insert(
      "stock",
      {
        'dateStock': stock.dateStock.toIso8601String(),
        'article': stock.articleId,
        'entete': stock.enteteId,
        'quantite': stock.quantite,
      },
    );
  }

  Future<List<Stock>> getStocks({required int enteteId}) async {
    // Added enteteId as a required parameter
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock',
      columns: [
        'stock.id',
        'dateStock',
        'stock.article', // Select 'article' from 'stock' table
        'stock.entete',
        'quantite',
      ],
      where: 'stock.entete = ?', // Filter by enteteId
      whereArgs: [enteteId], // Pass enteteId here
    );
    return List.generate(maps.length, (i) {
      return Stock.fromMap(maps[i]);
    });
  }
  // Add CRUD methods for Stock if needed (e.g., getStock, updateStock, deleteStock)
}
*/

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JSON/users.dart';
import '../models/article.dart';
import '../models/stock.dart';
import '../models/entete.dart';

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
    Designation_article TEXT NOT NULL,
    Code_a_barres INTEGER   
  )
  ''';

  String _enteteTable = '''
  CREATE TABLE entete (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dateEntete TEXT NOT NULL,
    description TEXT NOT NULL
  )
  ''';

  String _stockTable = '''
  CREATE TABLE stock (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dateStock TEXT NOT NULL,
    article INTEGER,
    entete INTEGER, 
    quantite INTEGER,
    FOREIGN KEY (article) REFERENCES articles (id),
    FOREIGN KEY (entete) REFERENCES entete (id)
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

    return openDatabase(path, version: 4, onCreate: (db, version) async {
      await db.execute(_userTable);
      await db.execute(_articleTable);
      await db.execute(_enteteTable);
      await db.execute(_stockTable);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 3) {
        await db
            .execute('ALTER TABLE articles ADD COLUMN Code_a_barres INTEGER');
      }
      if (oldVersion < 4) {
        await db.execute(_enteteTable);
        await db.execute(
            'ALTER TABLE stock ADD COLUMN entete INTEGER REFERENCES entete(id)');
      }
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

    // Create the map for the update, only including non-null or non-empty values
    final updateData = <String, dynamic>{};
    if (article.refArticle.isNotEmpty) {
      updateData['Ref_article'] = article.refArticle;
    }
    if (article.designationArticle.isNotEmpty) {
      updateData['Designation_article'] = article.designationArticle;
    }
    if (article.codeABarres != null) {
      updateData['Code_a_barres'] = article.codeABarres;
    }

    // Perform the update if there are any values to update
    if (updateData.isNotEmpty) {
      return await db.update(
        "articles",
        updateData,
        where: 'id = ?',
        whereArgs: [article.id],
      );
    } else {
      return 0; // No changes were made
    }
  }

  Future<int> deleteArticle(int id) async {
    final db = await database;
    return await db.delete("articles", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertEntete(Entete entete) async {
    final db = await database;
    return db.insert("entete", entete.toMap());
  }

  Future<List<Entete>> getEntetes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("entete");
    return List.generate(maps.length, (i) {
      return Entete.fromMap(maps[i]);
    });
  }

  Future<int> updateEntete(Entete entete) async {
    final db = await database;
    return db.update(
      "entete",
      entete.toMap(),
      where: 'id = ?',
      whereArgs: [entete.id],
    );
  }

  Future<int> deleteEntete(int id) async {
    final db = await database;
    return await db.delete("entete", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return db.insert(
      "stock",
      {
        'dateStock': stock.dateStock.toIso8601String(),
        'article': stock.articleId,
        'entete': stock.enteteId,
        'quantite': stock.quantite,
      },
    );
  }

  Future<List<Stock>> getStocks({required int enteteId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock',
      columns: [
        'stock.id',
        'dateStock',
        'stock.article',
        'stock.entete',
        'quantite',
      ],
      where: 'stock.entete = ?',
      whereArgs: [enteteId],
    );
    return List.generate(maps.length, (i) {
      return Stock.fromMap(maps[i]);
    });
  }

  // Add CRUD methods for Stock if needed (e.g., getStock, updateStock, deleteStock)
}
