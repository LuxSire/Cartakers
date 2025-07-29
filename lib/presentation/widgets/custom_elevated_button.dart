import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/theme/typography.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final TextStyle? textStyle;
  final double? height; // Add height parameter

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.textStyle,
    this.height, // Initialize height parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, // Apply the height if provided
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style:
                textStyle ??
                AppTypography.headingSmall.copyWith(
                  color: textColor ?? Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
