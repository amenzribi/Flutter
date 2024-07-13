class Article {
  final int id;
  final String refArticle;
  final String designationArticle;
  final int codeABarres; // Add the new field

  Article({
    required this.id,
    required this.refArticle,
    required this.designationArticle,
    required this.codeABarres, // Include in constructor
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as int,
      refArticle: map['Ref_article'] as String,
      designationArticle: map['Designation_article'] as String,
      codeABarres:
          map['Code_a_barres'] ?? '', // Use the null-aware operator (??)
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //  'id': id,
      'Ref_article': refArticle,
      'Designation_article': designationArticle,
      'Code_a_barres': codeABarres, // Include in toMap
    };
  }
}
