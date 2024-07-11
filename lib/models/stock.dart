import 'package:flutter_sqlite_auth_app/models/article.dart';

class Stock {
  final int id;
  final DateTime dateStock;
  final Article article;
  final int quantite;

  Stock({
    required this.id,
    required this.dateStock,
    required this.article,
    required this.quantite,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'] as int,
      dateStock: DateTime.parse(map['dateStock']),
      article: Article.fromMap(map['article']),
      quantite: map['quantite'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateStock': dateStock.toIso8601String(), // Utilisez toIso8601String()
      'article': article.toMap(),
      'quantite': quantite,
    };
  }
}
