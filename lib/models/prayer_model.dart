import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerModel {
  final String id;
  final String title;
  final String content;
  final bool isAnswered;
  final DateTime? createdAt;

  PrayerModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isAnswered,
    this.createdAt,
  });

  factory PrayerModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];
    return PrayerModel(
      id: doc.id,
      title: (d['title'] ?? '') as String,
      content: (d['content'] ?? '') as String,
      isAnswered: (d['isAnswered'] ?? false) as bool,
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
