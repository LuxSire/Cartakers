import 'package:flutter/material.dart';
import '../../responsive/responsive_design.dart';
import '../../responsive/screens/desktop_layout.dart';
import '../../responsive/screens/mobile_layout.dart';
import '../../responsive/screens/tablet_layout.dart';
import '../../../../services/theme_service.dart';
import 'package:get/get.dart';

/// Template for the overall site layout, responsive to different screen sizes
class TSiteTemplate extends StatelessWidget 
{
  const TSiteTemplate({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
    this.useLayout = true,
  });

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() {
      // Reference the observable so Obx knows when to rebuild
      final isDark = themeService.isDarkMode.value;
        return Builder(
        builder: (context) {
        debugPrint('TSiteTemplate context: ${context.hashCode}, scaffoldBackgroundColor: ${Get.theme.scaffoldBackgroundColor}');
        return Scaffold
        (

        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: TResponsiveWidget
        (
          desktop: useLayout
              ? DesktopLayout(body: desktop)
              : desktop ?? Container(),
          tablet: useLayout
              ? TabletLayout(body: tablet ?? desktop)
              : tablet ?? desktop ?? Container(),
          mobile: useLayout
              ? MobileLayout(body: mobile ?? desktop)
              : mobile ?? desktop ?? Container(),
            ),
          );
        },
      );
    });
  }
}