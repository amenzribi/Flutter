import 'package:flutter_sqlite_auth_app/models/article.dart';

class Stock {
  final int id;
  final DateTime dateStock;
  final int articleId; // Change 'article' to 'articleId'
  final int quantite;

  Stock({
    required this.id,
    required this.dateStock,
    required this.articleId,
    required this.quantite,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'] as int,
      dateStock: DateTime.parse(map['dateStock']),
      articleId: map['article'] as int, // Retrieve articleId from map
      quantite: map['quantite'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateStock': dateStock.toIso8601String(),
      'article': articleId, // Store articleId in map
      'quantite': quantite,
    };
  }
}
