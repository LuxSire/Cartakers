import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/theme/typography.dart';

extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get outlineBlueGray1 => const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.blueGray100, width: 1),
  );
  static UnderlineInputBorder get underLineGray => const UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.gray20001),
  );
  static OutlineInputBorder get outlineGray => OutlineInputBorder(
    borderRadius: BorderRadius.circular(22.0),
    borderSide: const BorderSide(color: AppColors.gray100, width: 1),
  );
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = false,
    this.validator,
  });

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? textStyle;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildTextField(context))
        : _buildTextField(context);
  }

  Widget _buildTextField(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: boxDecoration,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,

        enableSuggestions: true,
        autofillHints: const [AutofillHints.oneTimeCode],
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        style: textStyle ?? AppTypography.titleSmallMedium,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        textInputAction:
            maxLines == null || maxLines! > 1
                ? TextInputAction.newline
                : textInputAction,
        keyboardType:
            maxLines == null || maxLines! > 1
                ? TextInputType.multiline
                : textInputType,
        maxLines: maxLines, // Dynamic growth if null
        scrollPadding:
            scrollPadding ??
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: _buildInputDecoration(context),
        validator: validator,
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: hintStyle ?? AppTypography.bodyMedium,
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      isDense: true,
      contentPadding: contentPadding ?? const EdgeInsets.all(12.0),
      fillColor:
          readOnly
              ? (isDarkMode
                  ? AppColors.gray700
                  : AppColors.gray200) // Adapt to dark mode
              : fillColor,
      filled: true, // Ensure background is applied
      border:
          borderDecoration ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: AppColors.blueGray100,
              width: 1,
            ),
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
          borderDecoration ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1,
            ),
          ),
    );
  }
}
