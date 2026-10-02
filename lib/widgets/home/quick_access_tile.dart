import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class QuickAccessTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback onTap;

  QuickAccessTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  State<QuickAccessTile> createState() => _QuickAccessTileState();
}

class _QuickAccessTileState extends State<QuickAccessTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final base = widget.backgroundColor ?? AppColors.cardCream;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: Duration(milliseconds: 100),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base.withOpacity(1.0), base.withOpacity(0.6)],
            ),
          ),
          child: Stack(
            children: [
              // Large faded watermark icon peeking from the corner
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  widget.icon,
                  size: 56,
                  color: (widget.iconColor ?? AppColors.primaryGreen).withOpacity(0.14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: widget.iconColor ?? AppColors.primaryGreen, size: 22),
                    SizedBox(height: 6),
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
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
    );
  }
}
