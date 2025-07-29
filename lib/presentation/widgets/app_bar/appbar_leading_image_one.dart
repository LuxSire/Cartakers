import 'package:flutter/material.dart';
import 'package:xm_frontend/presentation/widgets/custom_image_view.dart';

class AppbarLeadingImageOne extends StatelessWidget {
  const AppbarLeadingImageOne({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  });

  final double? height;
  final double? width;
  final String imagePath; // Made required
  final VoidCallback? onTap; // Changed to VoidCallback for better usability
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap, // Directly use the onTap callback
        child: CustomImageView(
          imagePath: imagePath,
          height: height ?? 24.0,
          width: width ?? 24.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
