import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkModel {
  final String id;
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
  final DateTime? createdAt;

  BookmarkModel({
    required this.id,
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
    this.createdAt,
  });

  /// Always one verse, e.g. "Proverbs 3:5"
  String get reference => '$bookName $chapter:$verse';

  /// Same verse = same id, so a verse can never be bookmarked twice.
  static String makeId(String bookId, int chapter, int verse) =>
      '${bookId}_${chapter}_$verse';

  factory BookmarkModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];
    return BookmarkModel(
      id: doc.id,
      bookId: (d['bookId'] ?? '') as String,
      bookName: (d['bookName'] ?? '') as String,
      chapter: (d['chapter'] ?? 1) as int,
      verse: (d['verse'] ?? 1) as int,
      text: (d['text'] ?? '') as String,
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
