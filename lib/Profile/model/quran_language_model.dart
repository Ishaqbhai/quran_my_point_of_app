
class QuranLanguageModel {
  final String name;

  QuranLanguageModel(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranLanguageModel && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
