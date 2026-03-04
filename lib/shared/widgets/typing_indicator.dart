import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// Animated three-dot typing indicator (iMessage / WhatsApp-style).
///
/// Usage:
/// ```dart
/// if (isTyping) const TypingIndicator()
/// ```
class TypingIndicator extends StatelessWidget {
  final String? userName;
  const TypingIndicator({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(delay: 0.ms),
                const SizedBox(width: 4),
                _Dot(delay: 200.ms),
                const SizedBox(width: 4),
                _Dot(delay: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Duration delay;
  const _Dot({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.textHint,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (ctrl) => ctrl.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -5,
          delay: delay,
          duration: 500.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(end: 0.85, duration: 200.ms);
  }
}
