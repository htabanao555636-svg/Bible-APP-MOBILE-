import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

/// Draws a soft sky (gradient), a sun or moon+stars, and two layers of
/// rolling hills with a couple of small trees. Fully vector, no image
/// files needed, and it adapts to light/dark mode automatically.
class _NatureScenePainter extends CustomPainter {
  final bool isDark;

  const _NatureScenePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky
    final skyColors = isDark
        ? [const Color(0xFF16241F), const Color(0xFF0E1512)]
        : [const Color(0xFFFFE9B8), const Color(0xFFFDF6E9)];
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: skyColors,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), skyPaint);

    // Sun / moon with a soft glow
    final center = Offset(w * 0.82, h * 0.28);
    final glowColor = isDark ? const Color(0xFF9FD8C6) : const Color(0xFFFFC066);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [glowColor.withOpacity(0.45), glowColor.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: center, radius: 60));
    canvas.drawCircle(center, 60, glowPaint);
    canvas.drawCircle(
      center,
      16,
      Paint()..color = isDark ? const Color(0xFFE7F3EC) : const Color(0xFFFFC94D),
    );

    if (isDark) {
      // A few small stars scattered around the moon
      final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
      final rand = Random(7);
      for (var i = 0; i < 10; i++) {
        final dx = rand.nextDouble() * w;
        final dy = rand.nextDouble() * (h * 0.5);
        canvas.drawCircle(Offset(dx, dy), 1.3, starPaint);
      }
    }

    // Back hill (lighter/further away)
    final backHill = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.25, h * 0.5, w * 0.55, h * 0.66)
      ..quadraticBezierTo(w * 0.8, h * 0.78, w, h * 0.6)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      backHill,
      Paint()..color = (isDark ? AppColors.moodTeal : AppColors.moodTeal).withOpacity(0.55),
    );

    // Front hill (closer, darker green)
    final frontHill = Path()
      ..moveTo(0, h * 0.85)
      ..quadraticBezierTo(w * 0.3, h * 0.68, w * 0.6, h * 0.82)
      ..quadraticBezierTo(w * 0.85, h * 0.92, w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = AppColors.primaryGreen.withOpacity(0.9));

    // A couple of small trees on the front hill
    void drawTree(double x, double baseY, double scale) {
      final trunkPaint = Paint()..color = AppColors.primaryGreen.withOpacity(0.95);
      canvas.drawRect(
        Rect.fromLTWH(x - 1.5 * scale, baseY - 6 * scale, 3 * scale, 8 * scale),
        trunkPaint,
      );
      final leafPaint = Paint()..color = (isDark ? AppColors.moodTeal : AppColors.moodTeal);
      for (var i = 0; i < 3; i++) {
        final ty = baseY - (10 + i * 7) * scale;
        final path = Path()
          ..moveTo(x, ty - 9 * scale)
          ..lineTo(x - 8 * scale, ty)
          ..lineTo(x + 8 * scale, ty)
          ..close();
        canvas.drawPath(path, leafPaint);
      }
    }

    drawTree(w * 0.14, h * 0.9, 1.0);
    drawTree(w * 0.24, h * 0.94, 0.8);
  }

  @override
  bool shouldRepaint(covariant _NatureScenePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// A decorative hills-and-sky illustration you can drop behind any header.
class NatureScene extends StatelessWidget {
  final double height;

  const NatureScene({super.key, this.height = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(painter: _NatureScenePainter(isDark: AppColors.isDark)),
    );
  }
}
