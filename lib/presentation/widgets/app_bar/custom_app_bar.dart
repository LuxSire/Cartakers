import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xm_frontend/app/utils/size_utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.height,
    this.shape,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0.0,
    this.systemOverlayStyle,
  });

  final double? height;
  final ShapeBorder? shape;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Color backgroundColor;
  final double elevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      scrolledUnderElevation: 0, // stop shadow when scrolled
      shape: shape,
      toolbarHeight: height ?? 56.h,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle,
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(SizeUtils.width, height ?? 56.0);
}
