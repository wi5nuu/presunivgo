import 'package:flutter/material.dart';
import 'package:presunivgo/core/constants/app_colors.dart';

class PUAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? borderColor;
  final String? initials;

  final Color? backgroundColor;

  const PUAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 20,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 2)
            : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppColors.primary,
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? NetworkImage(imageUrl!)
            : null,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? Text(
                initials?.toUpperCase() ?? '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.8,
                ),
              )
            : null,
      ),
    );
  }
}
