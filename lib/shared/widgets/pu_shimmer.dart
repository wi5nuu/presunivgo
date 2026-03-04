import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class PUShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const PUShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withOpacity(0.5),
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget card() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PUShimmer(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PUShimmer(width: 120, height: 12),
                  SizedBox(height: 6),
                  PUShimmer(width: 80, height: 10),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          PUShimmer(height: 100),
          SizedBox(height: 12),
          PUShimmer(width: 150, height: 12),
        ],
      ),
    );
  }
}
