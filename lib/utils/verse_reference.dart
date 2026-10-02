import 'package:bible_app/services/bible_service.dart';

class ParsedReference {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;

  const ParsedReference({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
  });
}

class VerseReference {
  // Common alternate names -> our book ids
  static const _aliases = {
    'psalm': 'psalms',
    'songofsongs': 'songofsolomon',
    'canticles': 'songofsolomon',
  };

  // Matches a single verse only, e.g. "1 Peter 5:7"
  static final _pattern = RegExp(r'^(.+?)\s+(\d+):(\d+)$');

  static Future<ParsedReference?> parse(
    String reference,
    BibleService service,
  ) async {
    final match = _pattern.firstMatch(reference.trim());
    if (match == null) return null;

    var key = match.group(1)!.toLowerCase().replaceAll(RegExp(r'[\s.]'), '');
    key = _aliases[key] ?? key;

    final books = await service.loadBooks();
    for (final book in books) {
      if (book.id == key) {
        return ParsedReference(
          bookId: book.id,
          bookName: book.name,
          chapter: int.parse(match.group(2)!),
          verse: int.parse(match.group(3)!),
        );
      }
    }
    return null;
  }
}
