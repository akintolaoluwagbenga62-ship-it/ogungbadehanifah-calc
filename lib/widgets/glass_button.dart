import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GlassButtonType { number, operatorBtn, function, equals, clear, toggle }

/// A single calculator key styled as frosted liquid glass.
/// Different [GlassButtonType]s get a different tint so operators,
/// functions and the equals key are visually distinct at a glance.
class GlassButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final GlassButtonType type;
  final double fontSize;
  final bool active;

  const GlassButton({
    super.key,
    required this.label,
    required this.onTap,
    this.type = GlassButtonType.number,
    this.fontSize = 22,
    this.active = false,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  Color get _tint {
    switch (widget.type) {
      case GlassButtonType.operatorBtn:
        return AppColors.accentBlue;
      case GlassButtonType.function:
        return AppColors.accentPurple;
      case GlassButtonType.equals:
        return AppColors.accentOrange;
      case GlassButtonType.clear:
        return AppColors.accentRed;
      case GlassButtonType.toggle:
        return AppColors.accentGreen;
      case GlassButtonType.number:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tint = _tint;
    final highlighted = _pressed || widget.active;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tint.withValues(alpha: highlighted ? 0.30 : 0.14),
                    tint.withValues(alpha: 0.03),
                  ],
                ),
                border: Border.all(
                  color: tint.withValues(alpha: highlighted ? 0.55 : 0.30),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: tint.withValues(alpha: highlighted ? 0.30 : 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
