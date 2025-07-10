// class BooksModel {
//   final String name;
//   final String id;
//   final String url;

//   BooksModel({required this.name, required this.url, required this.id});

//   factory BooksModel.fromMap(Map<String, dynamic> map) {
//     return BooksModel(
//       name: map['name'] ?? '',
//       url: map['url'] ?? '',
//       id: map['id'] ?? '',
//     );
//   }
// }

class BooksModel {
  final String name;
  final String id;
  final String url;
  final String coverUrl;
  BooksModel({
    required this.name,
    required this.url,
    required this.id,
    required this.coverUrl,
  });

  factory BooksModel.fromMap(Map<String, dynamic> map) {
    return BooksModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
    );
  }
}
