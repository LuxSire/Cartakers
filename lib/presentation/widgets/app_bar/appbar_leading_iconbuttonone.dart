import 'package:flutter/material.dart';
import 'package:cartakers/app/utils/size_utils.dart';
import 'package:cartakers/presentation/widgets/custom_image_view.dart';

import '../custom_icon_button.dart';

class AppbarTrailingIconbuttonOne extends StatelessWidget {
  const AppbarTrailingIconbuttonOne({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
    this.decoration, // Added decoration parameter
  });

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration; // Define decoration here

  @override
  Widget build(BuildContext context) {
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
          decoration: decoration, // Pass the decoration here
          child: CustomImageView(imagePath: imagePath),
        ),
      ),
    );
  }
}
