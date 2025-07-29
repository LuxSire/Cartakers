import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration outlineGray(BuildContext context) => BoxDecoration(
    color:
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.gray700.withOpacity(0.1)
            : AppColors.whiteA700,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: AppColors.gray700, width: 1.0),
  );

  static BoxDecoration fillWhiteA(BuildContext context) => BoxDecoration(
    color:
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.gray700.withOpacity(0.2)
            : AppColors.whiteA700,
    borderRadius: BorderRadius.circular(20.0),
  );

  static BoxDecoration fillBlueGray(BuildContext context) => BoxDecoration(
    color:
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.blueGray90001
            : AppColors.blueGray10001,
    borderRadius: BorderRadius.circular(20.0),
  );

  static BoxDecoration outlinePrimary(BuildContext context) => BoxDecoration(
    color:
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.gray700.withOpacity(0.1)
            : AppColors.whiteA700,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: AppColors.primaryColor, width: 1.0),
  );

  static BoxDecoration fillPrimary(BuildContext context) => BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(8.0),
  );

  static BoxDecoration none(BuildContext context) => const BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child,
  });

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: iconButtonWidget(context),
        )
        : iconButtonWidget(context);
  }

  Widget iconButtonWidget(BuildContext context) => SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: DecoratedBox(
      decoration:
          decoration ??
          BoxDecoration(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.gray700.withOpacity(0.1)
                    : AppColors.blue50,
            borderRadius: BorderRadius.circular(20.0),
          ),
      child: IconButton(
        padding: padding ?? EdgeInsets.zero,
        onPressed: onTap,
        icon: child ?? Container(),
      ),
    ),
  );
}
