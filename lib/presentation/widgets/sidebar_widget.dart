import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/utils/image_constants.dart';
import 'package:xm_frontend/presentation/widgets/custom_image_view.dart';

class SidebarWidget extends StatefulWidget {
  final Function(String) onMenuSelected;

  const SidebarWidget({super.key, required this.onMenuSelected});

  @override
  _SidebarWidgetState createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  String selectedMenu = "Dashboard"; // Default selection

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;

    bool isTablet = screenWidth > 600 && screenWidth <= 900;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),

          // if mobile or table

          // 🔹 Logo Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup232x32,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 8),

                // Text Branding
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tenants10 ',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ), // Adjust logo path
          ),

          const SizedBox(height: 55),

          //  Menu Items
          _buildMenuItem(
            ImageConstant.imgNavHome,
            ImageConstant.imgNavHomeActive,
            "Dashboard",
            isFlutterIcon: true,
            iconData: Icons.home_outlined,
            activeIconData: Icons.home_outlined,
          ),

          const SizedBox(height: 5),
          _buildMenuItem(
            ImageConstant.imgNavProperties,
            ImageConstant.imgNavPropertiesActive,
            "Buildings & Units",
            isFlutterIcon: true,
            iconData: Icons.business,
            activeIconData: Icons.business_sharp,
          ),
          const SizedBox(height: 5),
          _buildMenuItem(
            ImageConstant.imgNavHome,
            ImageConstant.imgNavHomeActive,
            "Tenants & Contracts",
            isFlutterIcon: true,
            iconData: Icons.groups_2_outlined,
            activeIconData: Icons.groups_2_sharp,
          ),
          const SizedBox(height: 5),

          _buildMenuItem(
            ImageConstant.imgNavHome,
            ImageConstant.imgNavHomeActive,
            "Maintenance & Tasks",
            isFlutterIcon: true,
            iconData: Icons.assignment_outlined,
            activeIconData: Icons.assignment_sharp,
          ),
          const SizedBox(height: 5),

          _buildMenuItem(
            ImageConstant.imgNavAmenities,
            ImageConstant.imgNavAmenitiesActive,
            "Amenities & Bookings",
          ),
          const SizedBox(height: 5),
          _buildMenuItem(
            ImageConstant.imgNavHome,
            ImageConstant.imgNavHomeActive,
            "Communication",
            isFlutterIcon: true,
            iconData: Icons.wechat_outlined,
            activeIconData: Icons.wechat_sharp,
          ),
          const SizedBox(height: 5),

          _buildMenuItem(
            ImageConstant.imgNavHome,
            ImageConstant.imgNavHomeActive,
            "Settings & Management",
            isFlutterIcon: true,
            iconData: Icons.settings_outlined,
            activeIconData: Icons.settings_outlined,
          ),

          //  Spacer to push user profile & logout to bottom
          const Spacer(),

          // 🔹 User Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    ImageConstant.imgEllipse11953,
                    width: 35,
                    height: 35,
                  ), // User Imager
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Guy Hawkins",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Property Manager",
                      style: TextStyle(fontSize: 12, color: AppColors.gray500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Logout Button
          _buildMenuItem(
            ImageConstant.imgNavHome,
            ImageConstant.imgNavHomeActive,
            "Logoutssdsdsd",
            isFlutterIcon: true,
            iconData: Icons.logout,
            activeIconData: Icons.logout,
            isLogout: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String icon,
    String activeIcon,
    String title, {
    bool isLogout = false,
    bool isFlutterIcon = false,
    IconData? iconData,
    IconData? activeIconData,
  }) {
    bool isSelected = selectedMenu == title;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenu = title;
          });
          widget.onMenuSelected(title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              isFlutterIcon
                  ? Icon(
                    (isSelected ? activeIconData : iconData) ??
                        Icons.help_outline, // fallback
                    size: 24,
                    color: isSelected ? Colors.white : AppColors.gray700,
                  )
                  : CustomImageView(
                    imagePath: isSelected ? activeIcon : icon,
                    height: 24,
                    width: 24,
                  ),

              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    color:
                        isSelected
                            ? AppColors.whiteA700
                            : AppColors.blueGray90001,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
