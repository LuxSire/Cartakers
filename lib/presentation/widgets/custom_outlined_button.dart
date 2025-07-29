import 'package:flutter/material.dart';
import 'package:xm_frontend/presentation/widgets/custom_text_style.dart';
import 'base_button.dart';

class CustomOutlinedButton extends BaseButton {
  CustomOutlinedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.label,
    super.onPressed,
    super.buttonStyle,
    super.buttonTextStyle,
    super.isDisabled,
    super.alignment,
    super.height,
    super.width,
    super.margin,
    required super.text,
  }) : super(key: key);

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final Widget? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: _buildOutlinedButtonWidget(theme),
        )
        : _buildOutlinedButtonWidget(theme);
  }

  Widget _buildOutlinedButtonWidget(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: height ?? 36.0,
      width: width ?? double.maxFinite,
      margin: margin,
      decoration:
          decoration ??
          BoxDecoration(
            border: Border.all(
              color:
                  isDarkMode
                      ? Colors.grey[700]!
                      : Colors.grey[300]!, // Dynamic border color
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
      child: OutlinedButton(
        style:
            buttonStyle ??
            OutlinedButton.styleFrom(
              side: BorderSide(
                color:
                    isDarkMode
                        ? Colors.grey[700]!
                        : Colors.grey[300]!, // Dynamic outline color
                width: 1.5,
              ),
              backgroundColor:
                  isDarkMode
                      ? Colors.grey[900]
                      : Colors.white, // Dynamic background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox.shrink(),
            Text(
              text,
              style:
                  buttonTextStyle ??
                  CustomTextStyles.labelLargeDMSansGray700SemiBold.copyWith(
                    color:
                        isDarkMode
                            ? Colors.white
                            : Colors.grey[700], // Dynamic text color
                  ),
            ),
            rightIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
