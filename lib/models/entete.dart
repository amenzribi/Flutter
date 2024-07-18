class Entete {
  int? id;
  DateTime dateEntete;
  String description;

  Entete({
    this.id, // id est optionnel
    required this.dateEntete,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateEntete': dateEntete.toIso8601String(),
      'description': description,
    };
  }

  factory Entete.fromMap(Map<String, dynamic> map) {
    return Entete(
      id: map['id'],
      dateEntete: DateTime.parse(map['dateEntete']),
      description: map['description'],
    );
  }
}
