import 'package:bible_app/widgets/common/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/bookmark_model.dart';
import 'package:bible_app/models/prayer_model.dart';
import 'package:bible_app/models/quiz_question_model.dart';
import 'package:bible_app/providers/font_size_provider.dart';
import 'package:bible_app/providers/theme_provider.dart';
import 'package:bible_app/services/auth_service.dart';
import 'package:bible_app/services/bookmark_service.dart';
import 'package:bible_app/services/prayer_service.dart';
import 'package:bible_app/services/quiz_service.dart';
import 'package:bible_app/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  late final Stream<List<BookmarkModel>> _bookmarks =
      BookmarkService().watchBookmarks();
  late final Stream<List<PrayerModel>> _prayers = PrayerService().watchPrayers();
  late final Stream<List<QuizResultModel>> _quizzes =
      QuizService().watchResults();

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can log back in anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _auth.logOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: FontSizeController.instance,
      builder: (context, _) {
        final user = _auth.currentUser;
        final rawName = user?.displayName?.trim() ?? '';
        final name = rawName.isEmpty ? 'Friend' : rawName;
        final email = user?.email ?? '';
        final initial = name[0].toUpperCase();
        final isDark = ThemeController.instance.isDark;
        final fontLevel = FontSizeController.instance.level;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Profile')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
UserAvatar(initial: initial, radius: 42),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(email, style: TextStyle(color: AppColors.textMuted)),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen()),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<BookmarkModel>>(
                          stream: _bookmarks,
                          builder: (context, snap) => _StatBox(
                            label: 'Bookmarks',
                            value: snap.hasData ? '${snap.data!.length}' : '-',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StreamBuilder<List<PrayerModel>>(
                          stream: _prayers,
                          builder: (context, snap) => _StatBox(
                            label: 'Prayers',
                            value: snap.hasData ? '${snap.data!.length}' : '-',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StreamBuilder<List<QuizResultModel>>(
                          stream: _quizzes,
                          builder: (context, snap) {
                            var value = '-';
                            final results = snap.data;
                            if (results != null && results.isNotEmpty) {
                              final best = results
                                  .reduce((a, b) => a.score >= b.score ? a : b);
                              value = '${best.score}/${best.total}';
                            }
                            return _StatBox(label: 'Best quiz', value: value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDark
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Appearance',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose how BibleBayan looks on every screen.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 14),
                        SegmentedButton<bool>(
                          showSelectedIcon: false,
                          style: SegmentedButton.styleFrom(
                            foregroundColor: AppColors.textDark,
                            selectedForegroundColor: Colors.white,
                            selectedBackgroundColor: AppColors.primaryGreen,
                          ),
                          segments: const [
                            ButtonSegment<bool>(
                              value: false,
                              icon: Icon(Icons.light_mode_outlined),
                              label: Text('Light'),
                            ),
                            ButtonSegment<bool>(
                              value: true,
                              icon: Icon(Icons.dark_mode_outlined),
                              label: Text('Dark'),
                            ),
                          ],
                          selected: {isDark},
                          onSelectionChanged: (selection) {
                            // restoreTab: 4 keeps you on the Profile tab after the switch
                            ThemeController.instance
                                .setDark(selection.first, restoreTab: 4);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.text_fields, color: AppColors.primaryGreen),
                            const SizedBox(width: 8),
                            const Text(
                              'Reading Text Size',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applies to Bible verses wherever you read them.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: FontSizeLevel.values.map((level) {
                            final selected = level == fontLevel;
                            return _FontSizeOption(
                              label: level.label,
                              scale: level.scale,
                              selected: selected,
                              onTap: () =>
                                  FontSizeController.instance.setLevel(level),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      onPressed: _confirmLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Log out'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FontSizeOption extends StatelessWidget {
  final String label;
  final double scale;
  final bool selected;
  final VoidCallback onTap;

  const _FontSizeOption({
    required this.label,
    required this.scale,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryGreen.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Aa',
              style: TextStyle(
                fontSize: 14 * scale,
                fontWeight: FontWeight.bold,
                color: selected ? AppColors.primaryGreen : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: selected ? AppColors.primaryGreen : AppColors.textMuted,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardCream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
