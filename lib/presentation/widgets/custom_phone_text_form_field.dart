import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:cartakers/app/theme/colors.dart';
import 'package:cartakers/app/theme/typography.dart';

class CustomPhoneTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? contentPadding;
  final String initialCountryCode;
  final void Function(PhoneNumber)? onChanged; // Change to accept PhoneNumber
  final bool filled;
  final Color? fillColor;
  final InputBorder? borderDecoration;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;

  const CustomPhoneTextFormField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    this.initialCountryCode = '',
    this.onChanged,
    this.filled = true,
    this.fillColor = Colors.white,
    this.borderDecoration,
    this.hintStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('CustomPhoneTextFormField.build:    ' + initialCountryCode);

    return IntlPhoneField(
      disableLengthCheck: true,

      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ??
            AppTypography.bodyTextSmall.copyWith(color: AppColors.gray500),
        contentPadding: contentPadding,
        border:
            borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.gray100, width: 1),
            ),
        enabledBorder:
            borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.blueGray100,
                width: 1,
              ),
            ),
        focusedBorder:
            borderDecoration?.copyWith(
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ) ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
        filled: filled,
        fillColor: fillColor,
      ),
      initialCountryCode: initialCountryCode,
      onChanged: (phone) {
        if (onChanged != null) {
          onChanged!(phone); // Pass the PhoneNumber object directly
        }
      },
      style: textStyle ?? AppTypography.bodyText,
    );
  }
}
