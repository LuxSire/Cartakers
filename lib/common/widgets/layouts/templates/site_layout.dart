import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../responsive/responsive_design.dart';
import '../../responsive/screens/desktop_layout.dart';
import '../../responsive/screens/mobile_layout.dart';
import '../../responsive/screens/tablet_layout.dart';
import '../../../../services/theme_service.dart';

/// Template for the overall site layout that handles:
/// - Responsive layout (desktop, tablet, mobile)
/// - Theme switching (light/dark mode)
/// - Layout toggling (with or without standard layout wrapper)
class TSiteTemplate extends StatelessWidget {
  /// Creates a site template with responsive layouts
  const TSiteTemplate({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
    this.useLayout = true,
  });

  /// The widget to display on desktop screens
  final Widget? desktop;

  /// The widget to display on tablet screens (falls back to desktop if null)
  final Widget? tablet;

  /// The widget to display on mobile screens (falls back to tablet or desktop if null)
  final Widget? mobile;

  /// Whether to wrap content in standard layout (header, sidebar, etc.)
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeService = Get.find<ThemeService>();
      
      return Theme(
        data: themeService.isDarkMode.value 
            ? themeService.darkTheme 
            : themeService.lightTheme,
        child: Builder(
          builder: (context) {
            debugPrint('TSiteTemplate rebuilding with theme: ${Theme.of(context).brightness}');
            
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: TResponsiveWidget(
                  // Desktop layout
                  desktop: _buildLayout(
                    layout: DesktopLayout(body: desktop),
                    content: desktop,
                  ),
                  
                  // Tablet layout (falls back to desktop)
                  tablet: _buildLayout(
                    layout: TabletLayout(body: tablet ?? desktop),
                    content: tablet ?? desktop,
                  ),
                  
                  // Mobile layout (falls back to tablet then desktop)
                  mobile: _buildLayout(
                    layout: MobileLayout(body: mobile ?? tablet ?? desktop),
                    content: mobile ?? tablet ?? desktop,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  /// Builds the appropriate layout based on useLayout flag
  Widget _buildLayout({
    required Widget layout,
    required Widget? content,
  }) {
    if (!useLayout) {
      return content ?? Container();
    }
    return layout;
  }
}