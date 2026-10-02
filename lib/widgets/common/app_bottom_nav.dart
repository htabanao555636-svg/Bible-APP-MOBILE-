import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/app/app_icons.dart';

class _NavItem {
  final IconData icon;
  final IconData outline;
  final String label;
  const _NavItem(this.icon, this.outline, this.label);
}

const _items = [
  _NavItem(AppIcons.home, AppIcons.homeOutline, 'Home'),
  _NavItem(AppIcons.bible, AppIcons.bibleOutline, 'Bible'),
  _NavItem(AppIcons.discover, AppIcons.discoverOutline, 'Discover'),
  _NavItem(AppIcons.prayer, AppIcons.prayerOutline, 'Prayer'),
  _NavItem(AppIcons.profile, AppIcons.profileOutline, 'Profile'),
];

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(AppColors.isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              final item = _items[i];

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  customBorder: const StadiumBorder(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: EdgeInsets.symmetric(
                      horizontal: selected ? 10 : 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryGreen.withOpacity(0.14)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            selected ? item.icon : item.outline,
                            key: ValueKey(selected),
                            size: 24,
                            color: selected
                                ? AppColors.primaryGreen
                                : AppColors.textMuted,
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          child: selected
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    item.label,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
