import 'package:flutter/material.dart';

class CustomStatusContainer extends StatelessWidget {
  final String text; // The text to display
  final Color borderColor; // The color of the outline border
  final Color backgroundColor; // The background color of the container
  final Color textColor; // The color of the text
  final double borderRadius; // Optional: To customize the corner radius
  final EdgeInsetsGeometry padding; // Optional: Padding inside the container

  const CustomStatusContainer({
    Key? key,
    required this.text,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    this.borderRadius = 3.0,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
