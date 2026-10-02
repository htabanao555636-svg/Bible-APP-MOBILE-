import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String reference;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.reference,
  });
}

class QuizResultModel {
  final String id;
  final int score;
  final int total;
  final DateTime? createdAt;

  QuizResultModel({
    required this.id,
    required this.score,
    required this.total,
    this.createdAt,
  });

  factory QuizResultModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];
    return QuizResultModel(
      id: doc.id,
      score: (d['score'] ?? 0) as int,
      total: (d['total'] ?? 0) as int,
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
