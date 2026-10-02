import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

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
              color: AppColors.moodTeal.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.menu_book_outlined, size: 72, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 40),
          Text(
            "God's Word\nfor Your Journey",
            textAlign: TextAlign.center,
            style: AppText.pageTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 14),
          Text(
            'Find peace, guidance, and hope through the Bible — anytime, anywhere.',
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
