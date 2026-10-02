import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class MoodOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  MoodOptionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.75), color.withOpacity(0.45)],
          ),
        ),
        child: Stack(
          children: [
            // Large faded watermark icon peeking from the corner
            Positioned(
              right: -14,
              bottom: -14,
              child: Icon(
                icon,
                size: 76,
                color: AppColors.primaryGreen.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 30, color: AppColors.primaryGreen),
                  SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
