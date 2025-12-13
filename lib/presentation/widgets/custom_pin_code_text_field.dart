import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cartakers/app/theme/colors.dart';
import 'package:cartakers/utils/constants/colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField({
    super.key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
  });

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  final Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: pinCodeTextFieldWidget(theme, isDarkMode),
        )
        : pinCodeTextFieldWidget(theme, isDarkMode);
  }

  Widget pinCodeTextFieldWidget(ThemeData theme, bool isDarkMode) =>
      PinCodeTextField(
        appContext: context,
        controller: controller,

        length: 4,
        keyboardType: TextInputType.number,
        textStyle:
            textStyle ??
            theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        hintStyle:
            hintStyle ??
            theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enableActiveFill: true,
        cursorColor: theme.colorScheme.primary, // Dynamically set cursor color

        pinTheme: PinTheme(
          fieldHeight: 60.0,
          fieldWidth: 60.0,
          shape: PinCodeFieldShape.box,
          inactiveColor:
              isDarkMode ? theme.dividerColor : AppColors.blueGray100,
          activeColor: TColors.primary,
          inactiveFillColor: Colors.transparent,
          activeFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
          selectedColor: theme.colorScheme.primary,
        ),
        onChanged: (value) => onChanged(value),
        validator: validator,
      );
}
