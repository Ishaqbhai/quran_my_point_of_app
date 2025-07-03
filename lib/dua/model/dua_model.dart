class DuaModel {
  final String? id;
  final String title;
  final String arabic;
  final String english;
  final String tamil;
  final String urudu;
  final String hindi;
  final String malayalam;
  final String category;

  DuaModel({
    this.id,
    required this.title,
    required this.arabic,
    required this.english,
    required this.tamil,
    required this.urudu,
    required this.hindi,
    required this.malayalam,
    required this.category,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] as String?,
      title: json['tittle'] ?? '',
      arabic: json['dua_arabic'] ?? '',
      english: json['dua_meaning'] ?? '',
      tamil: json['meaning_tamil'] ?? '',
      urudu: json['meaning_urudu'] ?? '',
      malayalam: json['meaning_malayalam'] ?? '',
      category: json['category'] ?? '',
      hindi: json['meaning_hindi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tittle': title,
      'dua_arabic': arabic,
      'dua_meaning': english,
      'meaning_tamil': tamil,
      'meaning_urudu': urudu,
      'meaning_malayalam': malayalam,
      'meaning_hindi': hindi,
      'category': category,
    };
  }
}
