import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.moodOrange.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.self_improvement, size: 72, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 40),
          Text(
            'Pray. Reflect. Grow.',
            textAlign: TextAlign.center,
            style: AppText.pageTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 14),
          Text(
            'Keep a prayer journal, save favorite verses, and take part in bite-sized Bible quizzes.',
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
