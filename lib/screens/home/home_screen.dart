import 'package:bible_app/screens/quiz/quiz_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/services/auth_service.dart';
import 'package:bible_app/screens/bookmarks/bookmarks_screen.dart';
import 'package:bible_app/widgets/common/user_avatar.dart';
import 'package:bible_app/widgets/home/daily_verse_card.dart';
import 'package:bible_app/widgets/home/quick_access_tile.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _greetingAnim;
  late final Animation<double> _cardAnim;
  late final List<Animation<double>> _tileAnims;

  static const _headerHeight = 230.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _greetingAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _cardAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.6, curve: Curves.easeOut),
    );
    _tileAnims = List.generate(6, (i) {
      final start = (0.35 + i * 0.07).clamp(0.0, 1.0);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _greetingWord() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }

  Widget _fadeSlide(Animation<double> anim, Widget child) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final rawName = authService.currentUser?.displayName?.trim() ?? '';
    final name = rawName.isEmpty ? 'Friend' : rawName;
    final initial = name[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'BibleBayan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            shadows: [Shadow(blurRadius: 6, color: Colors.black45)],
          ),
        ),
        actions: [
          const IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: null,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => widget.onNavigateToTab?.call(4),
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.white70, width: 1.5),
                  ),
                ),
                child: UserAvatar(initial: initial, radius: 14),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Header photo with a rounded bottom edge and a readability gradient.
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: SizedBox(
              height: _headerHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/verse_of_the_day_background.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black38, Colors.transparent, Colors.black54],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 44,
                    child: _fadeSlide(
                      _greetingAnim,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good ${_greetingWord()}, $name!',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'What would you like to explore today?',
                            style: TextStyle(
                              color: Colors.white70,
                              shadows: [Shadow(blurRadius: 6, color: Colors.black45)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, _headerHeight - 40, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fadeSlide(_cardAnim, const DailyVerseCard()),
                  const SizedBox(height: 28),
                  const Text(
                    'Quick Access',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: [
                      _fadeSlide(
                        _tileAnims[0],
                        QuickAccessTile(
                          icon: Icons.menu_book_outlined,
                          label: 'Read Bible',
                          backgroundColor: AppColors.moodTeal.withOpacity(0.5),
                          onTap: () => widget.onNavigateToTab?.call(1),
                        ),
                      ),
                      _fadeSlide(
                        _tileAnims[1],
                        QuickAccessTile(
                          icon: Icons.mood_outlined,
                          label: 'Mood Verse',
                          backgroundColor: AppColors.moodPurple.withOpacity(0.5),
                          onTap: () => widget.onNavigateToTab?.call(2),
                        ),
                      ),
                      _fadeSlide(
                        _tileAnims[2],
                        QuickAccessTile(
                          icon: Icons.volunteer_activism_outlined,
                          label: 'Prayer Journal',
                          backgroundColor: AppColors.moodOrange.withOpacity(0.5),
                          onTap: () => widget.onNavigateToTab?.call(3),
                        ),
                      ),
                      _fadeSlide(
                        _tileAnims[3],
                        QuickAccessTile(
                          icon: Icons.bookmark_border,
                          label: 'Bookmarks',
                          backgroundColor: AppColors.moodPink.withOpacity(0.5),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const BookmarksScreen()),
                          ),
                        ),
                      ),
                      _fadeSlide(
                        _tileAnims[4],
                        QuickAccessTile(
                          icon: Icons.emoji_events_outlined,
                          label: 'Bible Quiz',
                          backgroundColor: AppColors.moodYellow.withOpacity(0.5),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizStartScreen())),
                        ),
                      ),
                      _fadeSlide(
                        _tileAnims[5],
                        QuickAccessTile(
                          icon: Icons.grid_view_rounded,
                          label: 'More',
                          backgroundColor: AppColors.moodBlue.withOpacity(0.5),
                          onTap: () => widget.onNavigateToTab?.call(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
