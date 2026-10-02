import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bible_app/models/bookmark_model.dart';

class BookmarkService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('bookmarks');
  }

  /// Live list of the user's bookmarks, newest first.
  Stream<List<BookmarkModel>> watchBookmarks() {
    final col = _col;
    if (col == null) return Stream.value([]);

    return col.snapshots().map((snap) {
      final now = DateTime.now();
      final list = snap.docs.map(BookmarkModel.fromDoc).toList();
      list.sort((a, b) =>
          (b.createdAt ?? now).compareTo(a.createdAt ?? now));
      return list;
    });
  }

  Future<void> add({
    required String bookId,
    required String bookName,
    required int chapter,
    required int verse,
    required String text,
  }) async {
    final col = _col;
    if (col == null) return;

    await col.doc(BookmarkModel.makeId(bookId, chapter, verse)).set({
      'bookId': bookId,
      'bookName': bookName,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> remove(String id) async {
    await _col?.doc(id).delete();
  }
}
