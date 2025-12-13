import 'package:flutter/material.dart';
import 'package:cartakers/presentation/widgets/custom_image_view.dart';

class AppbarTrailingImage extends StatelessWidget {
  const AppbarTrailingImage({
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
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: CustomImageView(
          imagePath: imagePath!,
          height: height ?? 24.0,
          width: width ?? 24.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
