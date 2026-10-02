import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

enum OptionState { idle, correct, wrong, dimmed }

class QuizOptionTile extends StatelessWidget {
  final String label;
  final OptionState state;
  final VoidCallback? onTap;

  const QuizOptionTile({
    super.key,
    required this.label,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    Color border;
    IconData? icon;
    Color iconColor = AppColors.primaryGreen;

    switch (state) {
      case OptionState.correct:
        background = AppColors.moodTeal.withValues(alpha: 0.6);
        border = AppColors.primaryGreen;
        icon = Icons.check_circle;
        break;
      case OptionState.wrong:
        background = AppColors.moodPink.withValues(alpha: 0.7);
        border = Colors.red.shade400;
        icon = Icons.cancel;
        iconColor = Colors.red.shade400;
        break;
      case OptionState.dimmed:
        background = AppColors.cardCream.withValues(alpha: 0.5);
        border = Colors.transparent;
        break;
      case OptionState.idle:
        background = AppColors.cardCream;
        border = Colors.transparent;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: state == OptionState.dimmed
                      ? AppColors.textMuted
                      : AppColors.textDark,
                ),
              ),
            ),
            if (icon != null) Icon(icon, color: iconColor),
          ],
        ),
      ),
    );
  }
}
