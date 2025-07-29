import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/theme/typography.dart';
import 'package:xm_frontend/data/models/selection_popup_model.dart';

extension DropDownStyleHelper on CustomDropDown {
  static OutlineInputBorder get outlineBlueGray1 => const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.blueGray100, width: 1),
  );
}

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    Key? key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.focusNode,
    this.icon,
    this.iconSize,
    this.autofocus = false,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.items,
    this.value,
    this.prefix,
    this.prefixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final FocusNode? focusNode;
  final Widget? icon;
  final double? iconSize;
  final bool? autofocus;
  final TextStyle? textStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final List<SelectionPopupModel>? items;
  final SelectionPopupModel? value; // Currently selected value
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<SelectionPopupModel>? validator;
  final Function(SelectionPopupModel?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return alignment != null
        ? Align(alignment: alignment ?? Alignment.center, child: dropDownWidget)
        : dropDownWidget;
  }

  Widget get dropDownWidget => Container(
    width: width ?? double.maxFinite,
    decoration: boxDecoration,
    child: DropdownButtonFormField<SelectionPopupModel>(
      value: value, // Ensure this matches an item in `items`
      focusNode: focusNode,
      icon: icon,
      iconSize: iconSize ?? 24,
      autofocus: autofocus!,
      isExpanded: true,
      style:
          textStyle ??
          AppTypography.titleFormBlack900Medium.copyWith(
            color: textStyle?.color ?? Colors.black,
          ),
      hint: Text(
        hintText ?? "",
        style:
            hintStyle ??
            AppTypography.bodyMedium.copyWith(
              color: hintStyle?.color ?? Colors.grey,
            ),
        overflow: TextOverflow.ellipsis,
      ),
      items:
          items?.map((SelectionPopupModel item) {
            return DropdownMenuItem<SelectionPopupModel>(
              value: item, // Ensure this matches `value`
              child: Text(
                item.title,
                overflow: TextOverflow.ellipsis,
                style:
                    textStyle ??
                    AppTypography.bodyMedium.copyWith(
                      color: textStyle?.color ?? Colors.black,
                    ),
              ),
            );
          }).toList(),
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
    ),
  );

  InputDecoration get decoration => InputDecoration(
    prefixIcon: prefix,
    prefixIconConstraints: prefixConstraints,
    isDense: true,
    contentPadding: contentPadding ?? const EdgeInsets.all(10.0),
    fillColor: fillColor ?? AppColors.whiteA700,
    filled: filled,
    border:
        borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.blueGray100, width: 1),
        ),
    enabledBorder:
        borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.blueGray100, width: 1),
        ),
    focusedBorder: (borderDecoration ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)))
        .copyWith(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
        ),
  );
}
