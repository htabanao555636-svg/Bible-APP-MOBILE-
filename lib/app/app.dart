import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/providers/theme_provider.dart';
import 'package:bible_app/screens/auth/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final dark = ThemeController.instance.isDark;

        return MaterialApp(
          // A new key on every switch makes every screen pick up the new colors.
          key: ValueKey(dark),
          title: 'BibleBayan',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.current,
          home: AuthGate(),
        );
      },
    );
  }
}
