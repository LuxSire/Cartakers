import 'package:flutter/material.dart';
import 'package:xm_frontend/presentation/widgets/custom_image_view.dart';

class AppbarLeadingImageTwo extends StatelessWidget {
  const AppbarLeadingImageTwo({
    Key? key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  }) : super(key: key);

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
        borderRadius: BorderRadius.circular(24.0),
        onTap: () {
          onTap?.call();
        },
        child: CustomImageView(
          imagePath: imagePath!,
          height: height ?? 24.0,
          width: width ?? 24.0,
          fit: BoxFit.contain,
          radius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }
}
