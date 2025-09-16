import 'package:flutter/material.dart';
import '../../layouts/headers/header.dart';
import 'package:get/get.dart';
import '../../layouts/sidebars/sidebar.dart';
import 'package:xm_frontend/services/theme_service.dart';

/// Widget for the desktop layout
class DesktopLayout extends StatelessWidget {
  final Widget? body;

  DesktopLayout({super.key, this.body});

  /// Widget to be displayed as the body of the desktop layout

  /// Key for the scaffold widget
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
     final themeService = Get.find<ThemeService>();
    debugPrint('Sidebar started with themes: ${themeService.lightTheme}, ${themeService.darkTheme}');
    debugPrint('Sidebar: isDarkMode = ${themeService.isDarkMode.value}');
    debugPrint('Sidebar: themeMode = ${themeService.isDarkMode.value ? "dark" : "light"}');
    debugPrint('Sidebar: scaffoldBackgroundColor = ${themeService.isDarkMode.value ? themeService.darkTheme.scaffoldBackgroundColor : themeService.lightTheme.scaffoldBackgroundColor}');
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    debugPrint(' Sidebar Current scaffoldBackgroundColor: $bgColor');
    
    debugPrint('Sidebar context: ${context.hashCode}');
  return Scaffold(
    body: Row(
        children: [
              Builder(
              builder: (context) => const TSidebar(),
                ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                THeader(scaffoldKey: scaffoldKey), // Header
                Expanded(child: body ?? Container()), // Body
              ],
            ),
          ),
        ],
    )
      );
  }
}
