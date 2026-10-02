class BibleSearchResult {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  const BibleSearchResult({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });
}
