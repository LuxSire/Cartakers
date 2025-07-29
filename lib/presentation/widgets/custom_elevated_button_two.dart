import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/typography.dart';
import 'base_button.dart';

class CustomElevatedButtonTwo extends BaseButton {
  CustomElevatedButtonTwo({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
         text: text,
         onPressed: onPressed,
         buttonStyle: buttonStyle,
         isDisabled: isDisabled,
         buttonTextStyle: buttonTextStyle,
         height: height,
         width: width,
         alignment: alignment,
         margin: margin,
       );

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: _buildElevatedButtonWidget(context),
        )
        : _buildElevatedButtonWidget(context);
  }

  Widget _buildElevatedButtonWidget(BuildContext context) {
    return Container(
      height: height ?? 48.0,
      width: width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftIcon != null) ...[
              SizedBox(
                height: 24.0,
                width: 24.0, // Ensure icons are constrained
                child: leftIcon,
              ),
              const SizedBox(width: 8.0), // Space between icon and text
            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: buttonTextStyle ?? AppTypography.titleMedium,
              ),
            ),
            if (rightIcon != null) ...[
              const SizedBox(width: 8.0), // Space between text and icon
              SizedBox(
                height: 24.0,
                width: 24.0, // Ensure icons are constrained
                child: rightIcon,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
