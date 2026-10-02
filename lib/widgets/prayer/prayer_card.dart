import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/prayer_model.dart';

class PrayerCard extends StatelessWidget {
  final PrayerModel prayer;
  final VoidCallback onTap;
  final VoidCallback onToggleAnswered;
  final VoidCallback onDelete;

  const PrayerCard({
    super.key,
    required this.prayer,
    required this.onTap,
    required this.onToggleAnswered,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final date = prayer.createdAt == null
        ? 'Just now'
        : DateFormat('MMM d, yyyy').format(prayer.createdAt!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 14, 4, 14),
        decoration: BoxDecoration(
          color: prayer.isAnswered
              ? AppColors.moodTeal.withValues(alpha: 0.35)
              : AppColors.cardCream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (prayer.isAnswered)
                        Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.check_circle,
                              size: 18, color: AppColors.primaryGreen),
                        ),
                      Expanded(
                        child: Text(
                          prayer.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    prayer.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1.4),
                  ),
                  SizedBox(height: 8),
                  Text(
                    prayer.isAnswered ? '$date  •  Answered' : date,
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.textMuted),
              onSelected: (value) {
                if (value == 'answered') onToggleAnswered();
                if (value == 'delete') onDelete();
                if (value == 'edit') onTap();
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                  value: 'answered',
                  child: Text(prayer.isAnswered
                      ? 'Mark as active'
                      : 'Mark as answered'),
                ),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
