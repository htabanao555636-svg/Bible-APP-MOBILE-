import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bible_app/models/prayer_model.dart';

class PrayerService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('prayers');
  }

  /// Live list of the user's prayers, newest first.
  Stream<List<PrayerModel>> watchPrayers() {
    final col = _col;
    if (col == null) return Stream.value([]);

    return col.snapshots().map((snap) {
      final now = DateTime.now();
      final list = snap.docs.map(PrayerModel.fromDoc).toList();
      list.sort((a, b) =>
          (b.createdAt ?? now).compareTo(a.createdAt ?? now));
      return list;
    });
  }

  Future<void> add({required String title, required String content}) async {
    await _col?.add({
      'title': title,
      'content': content,
      'isAnswered': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> update({
    required String id,
    required String title,
    required String content,
  }) async {
    await _col?.doc(id).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> setAnswered(String id, bool answered) async {
    await _col?.doc(id).update({'isAnswered': answered});
  }

  Future<void> remove(String id) async {
    await _col?.doc(id).delete();
  }
}
