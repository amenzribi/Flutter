class Stock {
  final int id;
  final DateTime dateStock;
  final int articleId;
  final int enteteId;
  final int quantite;

  Stock({
    required this.id,
    required this.dateStock,
    required this.articleId,
    required this.enteteId,
    required this.quantite,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'] as int,
      dateStock: DateTime.parse(map['dateStock']),
      articleId: map['articleId'] as int,
      enteteId: map['enteteId'] as int,
      quantite: map['quantite'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateStock': dateStock.toIso8601String(),
      'articleId': articleId,
      'enteteId': enteteId,
      'quantite': quantite,
    };
  }
}
