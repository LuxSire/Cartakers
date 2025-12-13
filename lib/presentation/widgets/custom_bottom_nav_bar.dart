import 'package:flutter/material.dart';
import 'package:cartakers/app/localization/app_localization.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color unselectedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.6);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: primaryColor,
      selectedItemColor: backgroundColor,
      unselectedItemColor: unselectedColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        _buildBottomNavItem(
          icon: Icons.home,
          label: 'Home',
          index: 0,
          context: context,
        ),
        _buildBottomNavItem(
          icon: Icons.settings,
          label: AppLocalization.of(context).translate('nav_bar.settings'),
          index: 1,
          context: context,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color:
            currentIndex == index
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      label: label,
    );
  }
}
