class BooksModel {
  final String name;
  final String id;
  final String url;

  BooksModel({required this.name, required this.url, required this.id});

  factory BooksModel.fromMap(Map<String, dynamic> map) {
    return BooksModel(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      id: map['id'] ?? '',
    );
  }
}
