class Article {
  final int id;
  final String refArticle;
  final String designationArticle;

  Article({
    required this.id,
    required this.refArticle,
    required this.designationArticle,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as int,
      refArticle: map['Ref_article'] as String,
      designationArticle: map['Designation_article'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //  'id': id,
      'Ref_article': refArticle,
      'Designation_article': designationArticle,
    };
  }
}
