import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bible_app/services/auth_service.dart';
import 'package:bible_app/screens/onboarding/splash_screen.dart';
import 'package:bible_app/screens/main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    AuthService.syncNow();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      initialData: authService.currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainScreen();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return SplashScreen();
      },
    );
  }
}
