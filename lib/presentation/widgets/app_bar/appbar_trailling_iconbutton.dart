import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/utils/size_utils.dart';
import 'package:xm_frontend/presentation/widgets/custom_image_view.dart';

import '../custom_icon_button.dart';

class AppbarTrailingIconbutton extends StatelessWidget {
  const AppbarTrailingIconbutton({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  });

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomIconButton(
          height: height ?? 36.h,
          width: width ?? 56.h,
          padding: EdgeInsets.all(6.h),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? AppColors
                        .blueGray900 // Dark background for dark mode
                    : AppColors.whiteA700, // Light background for light mode
            borderRadius: BorderRadius.circular(12),
            boxShadow:
                isDarkMode
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: CustomImageView(imagePath: imagePath),
        ),
      ),
    );
  }
}
