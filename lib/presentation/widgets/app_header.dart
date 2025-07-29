import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final bool showSubtitle;
  final Color backgroundColor;
  final TextStyle? titleStyle;

  const AppHeader({
    super.key,
    required this.title,
    required this.logoPath,
    this.showSubtitle = false,
    this.backgroundColor = Colors.white,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            logoPath,
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (showSubtitle)
                const Text(
                  "Subtitle", // Optional subtitle
                  style:  TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
