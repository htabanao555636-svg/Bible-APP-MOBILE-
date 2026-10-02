import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bible_app/models/bible_book_model.dart';
import 'package:bible_app/models/bible_search_result.dart';

class BibleService {
  // static = shared by every BibleService instance, so heavy work happens once
  static List<BibleBookModel>? _cachedBooks;
  static List<dynamic>? _cachedBible;
  static final Map<String, List<List<String>>?> _chapterCache = {};

  Future<List<BibleBookModel>> loadBooks() async {
    if (_cachedBooks != null) return _cachedBooks!;

    final raw = await rootBundle.loadString('assets/bible/books_meta.json');
    final List<dynamic> data = jsonDecode(raw);
    final books = data.map((e) => BibleBookModel.fromJson(e)).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    _cachedBooks = books;
    return books;
  }

  Future<List<dynamic>> _loadBible() async {
    if (_cachedBible != null) return _cachedBible!;

    var raw = await rootBundle.loadString('assets/bible/kjv.json');
    if (raw.startsWith('\uFEFF')) raw = raw.substring(1);

    _cachedBible = jsonDecode(raw) as List<dynamic>;
    return _cachedBible!;
  }

  /// Returns chapters -> verses for a book, or null if not found.
  /// Cached per book, so search (which checks every book) only parses once.
  Future<List<List<String>>?> loadBookChapters(String bookId) async {
    if (_chapterCache.containsKey(bookId)) return _chapterCache[bookId];

    try {
      final books = await loadBooks();
      final book = books.firstWhere((b) => b.id == bookId);
      final bible = await _loadBible();

      final bookData = bible[book.order - 1] as Map<String, dynamic>;
      final List<dynamic> chapters = bookData['chapters'];

      final parsed = chapters
          .map((chapter) => (chapter as List<dynamic>)
              .map((v) => v.toString().replaceAll(RegExp(r'[{}]'), ''))
              .toList())
          .toList();

      _chapterCache[bookId] = parsed;
      return parsed;
    } catch (_) {
      _chapterCache[bookId] = null;
      return null;
    }
  }

  /// Returns the text of one verse, or null if it does not exist.
  Future<String?> loadVerse(String bookId, int chapter, int verse) async {
    final chapters = await loadBookChapters(bookId);
    if (chapters == null) return null;
    if (chapter < 1 || chapter > chapters.length) return null;

    final verses = chapters[chapter - 1];
    if (verse < 1 || verse > verses.length) return null;

    return verses[verse - 1];
  }

  /// Case-insensitive search across every book, up to [limit] matches.
  Future<List<BibleSearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final lower = trimmed.toLowerCase();
    final books = await loadBooks();
    final results = <BibleSearchResult>[];

    for (final book in books) {
      final chapters = await loadBookChapters(book.id);
      if (chapters == null) continue;

      for (var c = 0; c < chapters.length; c++) {
        final verses = chapters[c];
        for (var v = 0; v < verses.length; v++) {
          if (verses[v].toLowerCase().contains(lower)) {
            results.add(BibleSearchResult(
              bookId: book.id,
              bookName: book.name,
              chapter: c + 1,
              verse: v + 1,
              text: verses[v],
            ));
          }
        }
      }
    }

    return results;
  }
}
