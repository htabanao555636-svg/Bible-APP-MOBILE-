import 'package:bible_app/widgets/common/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/services/mood_verse_service.dart';
import 'package:bible_app/widgets/mood/mood_option_card.dart';

class MoodVerseScreen extends StatelessWidget {
  const MoodVerseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = MoodVerseService.moods;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Mood Verse')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How are you feeling today?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Pick a mood and receive a verse for it.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: moods.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    return MoodOptionCard(
                      label: mood.label,
                      icon: mood.icon,
                      color: mood.color,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MoodResultScreen(mood: mood),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodResultScreen extends StatefulWidget {
  final Mood mood;

  const MoodResultScreen({super.key, required this.mood});

  @override
  State<MoodResultScreen> createState() => _MoodResultScreenState();
}

class _MoodResultScreenState extends State<MoodResultScreen> {
  int _index = 0;

  void _nextVerse() {
    setState(() {
      _index = (_index + 1) % widget.mood.verses.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final verse = widget.mood.verses[_index];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.mood.label)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.mood.color.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(widget.mood.icon, color: AppColors.primaryGreen),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'A verse for when you feel ${widget.mood.label.toLowerCase()}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        BookmarkButton(reference: verse.reference, fallbackText: verse.text),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '"${verse.text}"',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.6,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      verse.reference,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Reflection',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                verse.reflection,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 28),
              ElevatedButton(
                onPressed: _nextVerse,
                child: Text('Another verse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
