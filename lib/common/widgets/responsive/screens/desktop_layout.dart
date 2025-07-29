import 'package:flutter/material.dart';
import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

/// Widget for the desktop layout
class DesktopLayout extends StatelessWidget {
  final Widget? body;

  DesktopLayout({super.key, this.body});

  /// Widget to be displayed as the body of the desktop layout

  /// Key for the scaffold widget
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: TSidebar()), // Sidebar
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
      ),
    );
  }
}
