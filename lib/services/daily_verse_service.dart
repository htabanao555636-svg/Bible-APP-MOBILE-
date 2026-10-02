import 'dart:math';
import 'package:bible_app/services/bible_service.dart';
import 'package:bible_app/utils/verse_reference.dart';

class DailyVerse {
  final String reference;
  final String text;

  DailyVerse({required this.reference, required this.text});
}

class DailyVerseService {
  // Single verses only. Add more here any time; the text is loaded from the KJV file.
  static const List<String> _references = [
    'Jeremiah 29:11', 'Proverbs 3:5', 'Proverbs 3:6', 'Psalm 23:1',
    'Psalm 23:4', 'Psalm 46:1', 'Psalm 119:105', 'Psalm 121:2',
    'Psalm 27:1', 'Psalm 37:4', 'Psalm 34:8', 'Psalm 118:24',
    'Psalm 30:5', 'Psalm 34:18', 'Isaiah 41:10', 'Isaiah 40:31',
    'Isaiah 26:3', 'Romans 8:28', 'Romans 12:2', 'Romans 15:13',
    'Romans 5:8', 'Romans 10:9', 'John 3:16', 'John 14:6',
    'John 14:27', 'John 8:12', 'John 15:5', 'John 16:33',
    'Matthew 6:33', 'Matthew 11:28', 'Matthew 5:16', 'Matthew 28:20',
    'Matthew 19:26', 'Mark 10:27', 'Luke 1:37', 'Philippians 4:6',
    'Philippians 4:13', 'Philippians 4:19', 'Galatians 2:20',
    'Galatians 5:22', 'Ephesians 2:8', 'Ephesians 6:10',
    '2 Corinthians 5:7', '2 Corinthians 12:9', '1 Corinthians 13:13',
    'Hebrews 11:1', 'Hebrews 13:8', 'James 1:5', 'James 4:8',
    '1 Peter 5:7', '1 John 4:19', '1 John 4:8', 'Joshua 1:9',
    'Deuteronomy 31:6', 'Lamentations 3:23', 'Micah 6:8',
    'Zephaniah 3:17', 'Joshua 24:15', '2 Timothy 1:7', 'Colossians 3:23',
    '1 Thessalonians 5:18', 'Nahum 1:7', 'Proverbs 16:3', 'Proverbs 18:10',
    'Exodus 14:14',
  ];

  final _bibleService = BibleService();

  // Whole days since 1970, so the number changes exactly once per calendar day.
  static int _dayNumber(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day)
        .difference(DateTime.utc(1970, 1, 1))
        .inDays;
  }

  /// Same date always gives the same verse. The order is shuffled, and each
  /// shuffle "round" uses every verse once before any verse repeats.
  String referenceForDate(DateTime date) {
    final day = _dayNumber(date);
    final count = _references.length;
    final round = day ~/ count;
    final position = day % count;

    final order = List<int>.generate(count, (i) => i)..shuffle(Random(round));
    return _references[order[position]];
  }

  Future<DailyVerse> getVerseFor(DateTime date) async {
    final raw = referenceForDate(date);

    try {
      final parsed = await VerseReference.parse(raw, _bibleService);
      if (parsed != null) {
        final text = await _bibleService.loadVerse(
            parsed.bookId, parsed.chapter, parsed.verse);
        if (text != null) {
          return DailyVerse(
            reference: '${parsed.bookName} ${parsed.chapter}:${parsed.verse}',
            text: text,
          );
        }
      }
    } catch (_) {
      // fall through to the default below
    }

    return DailyVerse(
      reference: 'Jeremiah 29:11',
      text:
          'For I know the thoughts that I think toward you, saith the LORD, thoughts of peace, and not of evil, to give you an expected end.',
    );
  }
}
