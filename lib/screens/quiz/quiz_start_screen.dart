import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/quiz_question_model.dart';
import 'package:bible_app/services/quiz_service.dart';
import 'package:bible_app/screens/quiz/quiz_screen.dart';

class QuizStartScreen extends StatelessWidget {
  const QuizStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = QuizService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Bible Quiz')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.moodYellow.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(Icons.emoji_events_outlined,
                        size: 56, color: AppColors.primaryGreen),
                    SizedBox(height: 12),
                    Text(
                      'Test Your Bible Knowledge',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '10 random questions. See how many you get right!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => QuizScreen()),
                        );
                      },
                      child: Text('Start Quiz'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              StreamBuilder<List<QuizResultModel>>(
                stream: service.watchResults(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final results = snapshot.data!;
                  if (results.isEmpty) {
                    return Text(
                      'No quizzes played yet. Your scores will show up here.',
                      style: TextStyle(color: AppColors.textMuted),
                    );
                  }

                  final best = results
                      .map((r) => r.score)
                      .reduce((a, b) => a > b ? a : b);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatBox(
                                label: 'Best score',
                                value: '$best / ${results.first.total}'),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _StatBox(
                                label: 'Quizzes played',
                                value: '${results.length}'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Recent results',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      ...results.take(5).map((r) {
                        final date = r.createdAt == null
                            ? 'Just now'
                            : DateFormat('MMM d, yyyy  •  h:mm a')
                                .format(r.createdAt!);
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardCream,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(date,
                                    style: TextStyle(
                                        color: AppColors.textMuted)),
                              ),
                              Text(
                                '${r.score} / ${r.total}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardCream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: 4),
          Text(label,
              style:
                  TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
