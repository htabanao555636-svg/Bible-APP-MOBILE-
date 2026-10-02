import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
              color: AppColors.moodPurple.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_outline, size: 72, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 40),
          Text(
            'Be Encouraged\nEvery Day',
            textAlign: TextAlign.center,
            style: AppText.pageTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 14),
          Text(
            'Get a daily verse, explore meaningful reflections, and build a stronger faith.',
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
