import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/services/auth_service.dart';

/// A circular avatar that shows the user's uploaded photo, or their
/// initial if they haven't set one. Updates instantly everywhere it's
/// used whenever the photo changes.
class UserAvatar extends StatelessWidget {
  final String initial;
  final double radius;

  const UserAvatar({
    super.key,
    required this.initial,
    this.radius = 42,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: AuthService.photoUrlNotifier,
      builder: (context, dataUri, _) {
        if (dataUri != null && dataUri.startsWith('data:image')) {
          try {
            final base64Part = dataUri.split(',').last;
            final bytes = base64Decode(base64Part);
            return CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.primaryGreen,
              backgroundImage: MemoryImage(bytes),
            );
          } catch (_) {
            // fall through to initial below if decoding ever fails
          }
        }

        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primaryGreen,
          child: Text(
            initial,
            style: TextStyle(
              fontSize: radius * 0.8,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
