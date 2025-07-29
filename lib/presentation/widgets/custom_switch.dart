import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/utils/size_utils.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.onChange,
    this.alignment,
    this.value,
    this.width,
    this.height,
    this.margin,
  });

  final Alignment? alignment;
  final bool? value;
  final Function(bool) onChange;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 30.h, // Default height
      width: width ?? 60.h, // Default width
      margin: margin ?? EdgeInsets.symmetric(horizontal: 8.h),
      alignment: alignment,
      child: switchWidget,
    );
  }

  Widget get switchWidget => FlutterSwitch(
    value: value ?? false,
    height: 24.h, // Increased height
    width: 48.h, // Increased width
    toggleSize: 20.h, // Increased toggle size
    borderRadius: 12.h, // Adjusted for smoother corners
    switchBorder: Border.all(
      color: value == true ? AppColors.primaryColor : AppColors.gray500,
      width: 0.8.h,
    ),
    activeColor: AppColors.primaryColor.withOpacity(0.8),
    activeToggleColor: AppColors.whiteA700,
    inactiveColor: AppColors.gray200,
    inactiveToggleColor: AppColors.gray500,
    onToggle: (value) {
      onChange(value);
    },
  );
}
