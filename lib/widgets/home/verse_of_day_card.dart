import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/widgets/common/bookmark_button.dart';

class VerseOfDayCard extends StatelessWidget {
  final String reference;
  final String text;
  final VoidCallback? onBookmark;

  VerseOfDayCard({
    super.key,
    required this.reference,
    required this.text,
    this.onBookmark,
  });

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/verse_of_the_day_background.jpg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 16,
                          child: Text(
                            reference,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"$text"',
                          style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textDark),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            BookmarkButton(reference: reference, fallbackText: text),
                            SizedBox(width: 4),
                            Text('Save', style: TextStyle(color: AppColors.textMuted)),
                            SizedBox(width: 24),
                            IconButton(
                              icon: Icon(Icons.copy_outlined),
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: '"$text"\n$reference'));
                                if (context.mounted) {
                                  Navigator.pop(sheetContext);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Copied $reference')),
                                  );
                                }
                              },
                            ),
                            Text('Copy', style: TextStyle(color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardCream,
              AppColors.moodYellow.withOpacity(0.5),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Large faded watermark icon peeking from the corner
            Positioned(
              right: -18,
              bottom: -18,
              child: Icon(
                Icons.wb_sunny_rounded,
                size: 110,
                color: AppColors.primaryGreen.withOpacity(0.12),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wb_sunny_outlined, color: AppColors.primaryGreen, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Verse of the Day',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      BookmarkButton(reference: reference, fallbackText: text),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '"$text"',
                    style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.textDark),
                  ),
                  SizedBox(height: 12),
                  Text(
                    reference,
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
