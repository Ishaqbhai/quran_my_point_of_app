class DuaCategoryModel {
  final String? id;
  final String category;

  DuaCategoryModel({this.id, required this.category});

  /// 🔁 From Supabase JSON to Dart
  factory DuaCategoryModel.fromJson(Map<String, dynamic> json) {
    return DuaCategoryModel(id: json['id'], category: json['category'] ?? '');
  }

  /// 🔄 From Dart to Supabase-compatible JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'category': category};
  }
}
