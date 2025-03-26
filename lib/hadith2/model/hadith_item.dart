class HadithItem {
  final String title;
  final String arabic;
  final String english;

  HadithItem({
    required this.title,
    required this.arabic,
    required this.english,
  });

  @override
  String toString() {
    return 'HadithItem { title: $title, arabic: $arabic, english: $english }';
  }
}