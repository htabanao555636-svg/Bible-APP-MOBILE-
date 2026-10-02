import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class VerseTile extends StatelessWidget {
  final int number;
  final String text;
  final double fontSize;
  final bool bookmarked;
  final bool highlighted;
  final VoidCallback? onTap;

  const VerseTile({
    super.key,
    required this.number,
    required this.text,
    this.fontSize = 15,
    this.bookmarked = false,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    if (highlighted) {
      background = AppColors.moodYellow.withOpacity(0.6);
    } else if (bookmarked) {
      background = AppColors.primaryGreen.withOpacity(0.10);
    } else {
      background = Colors.transparent;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$number  ',
                      style: TextStyle(
                        fontSize: fontSize - 2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    TextSpan(
                      text: text,
                      style: TextStyle(
                        fontSize: fontSize,
                        height: 1.6,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (bookmarked)
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 2),
                child: Icon(Icons.bookmark, size: 18, color: AppColors.primaryGreen),
              ),
          ],
        ),
      ),
    );
  }
}
