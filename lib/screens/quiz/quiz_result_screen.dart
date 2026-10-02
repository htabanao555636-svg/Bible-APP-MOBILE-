import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/screens/quiz/quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({super.key, required this.score, required this.total});

  String get _message {
    final ratio = total == 0 ? 0 : score / total;
    if (ratio == 1) return 'Perfect score! Amazing!';
    if (ratio >= 0.8) return 'Great job! You know your Bible well.';
    if (ratio >= 0.5) return 'Good effort! Keep reading and learning.';
    return 'Keep going! Every verse you read helps you grow.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events,
                  size: 80, color: AppColors.primaryGreen),
              SizedBox(height: 16),
              Text(
                '$score / $total',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: AppColors.textMuted, height: 1.4),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => QuizScreen()),
                  );
                },
                child: Text('Play Again'),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 52),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Back to Quiz Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
