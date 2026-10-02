import 'package:flutter/material.dart';
import 'package:bible_app/providers/theme_provider.dart';
import 'package:bible_app/widgets/common/app_bottom_nav.dart';
import 'package:bible_app/screens/home/home_screen.dart';
import 'package:bible_app/screens/bible/bible_books_screen.dart';
import 'package:bible_app/screens/mood/mood_verse_screen.dart';
import 'package:bible_app/screens/prayer/prayer_journal_screen.dart';
import 'package:bible_app/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // After a theme switch, return to the tab the user was on (Profile).
    _currentIndex = ThemeController.instance.takeRestoreTab();
  }

  void _goToTab(int index) => setState(() => _currentIndex = index);

  late final List<Widget> _screens = [
    HomeScreen(onNavigateToTab: _goToTab),
    BibleBooksScreen(),
    MoodVerseScreen(),
    PrayerJournalScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}
