import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/app/utils/image_constants.dart';
import 'package:cartakers/app/utils/user_provider.dart';
import 'package:cartakers/presentation/widgets/custom_image_view.dart';

enum BottomBarEnum { Home, MyBookings, MyRequests, Community, Profile }

class CustomBottomBar extends StatefulWidget {
  final Function(BottomBarEnum)? onChanged;
  final BottomBarEnum selectedTab; // <-- Accept selected tab

  const CustomBottomBar({super.key, this.onChanged, required this.selectedTab});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // debugPrint('Selected Index: $selectedIndex');
  }

  @override
  void didUpdateWidget(covariant CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Only update `selectedIndex` if the selected tab has changed
    if (widget.selectedTab.index != selectedIndex) {
      setState(() {
        selectedIndex = widget.selectedTab.index;
      });
    }
  }

  void _onTabSelected(int index) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });

      // ✅ Notify HomeScreen of the tab change
      widget.onChanged?.call(BottomBarEnum.values[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    final userProvider = Provider.of<UserProvider>(context);

    final List<BottomMenuModel> bottomMenuList = [
      BottomMenuModel(
        icon: ImageConstant.imgNavHome,
        activeIcon: ImageConstant.imgNavHomeActive,
        title: AppLocalization.of(
          context,
        ).translate('bottom_navigation.lbl_home'),
        type: BottomBarEnum.Home,
        isProfile: false,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgHugeIconTimeAnd,
        activeIcon: ImageConstant.imgHugeIconTimeAndActive,
        title: AppLocalization.of(
          context,
        ).translate('bottom_navigation.lbl_my_bookings'),
        type: BottomBarEnum.MyBookings,
        isProfile: false,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgHugeIconNotes,
        activeIcon: ImageConstant.imgHugeIconNotesActive,
        title: AppLocalization.of(
          context,
        ).translate('bottom_navigation.lbl_my_requests'),
        type: BottomBarEnum.MyRequests,
        isProfile: false,
      ),
      BottomMenuModel(
        icon: ImageConstant.imgHugeIconUser,
        activeIcon: ImageConstant.imgHugeIconUserActive,
        title: AppLocalization.of(
          context,
        ).translate('bottom_navigation.lbl_community'),
        type: BottomBarEnum.Community,
        isProfile: false,
      ),
      BottomMenuModel(
        icon:
            userProvider.profileImage != ''
                ? userProvider.profileImage
                : ImageConstant.imgDefaultUser,
        activeIcon:
            userProvider.profileImage != ''
                ? userProvider.profileImage
                : ImageConstant.imgDefaultUser,
        title: AppLocalization.of(
          context,
        ).translate('bottom_navigation.lbl_profile'),
        type: BottomBarEnum.Profile,
        isProfile: true,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container(
        //   width: double.maxFinite,
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).bottomAppBarTheme.color,
        //     boxShadow: [
        //       BoxShadow(
        //         color: theme.shadowColor.withOpacity(0.1),
        //         spreadRadius: 2.0,
        //         blurRadius: 2.0,
        //         offset: const Offset(0, 0),
        //       ),
        //     ],
        //   ),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       CustomImageView(
        //         imagePath: ImageConstant.imgImage50x390,
        //         height: 50.0,
        //         width: double.maxFinite,
        //       )
        //     ],
        //   ),
        // ),
        Container(
          height: 85, // Set a fixed height for the bottom bar
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          color: Theme.of(context).bottomAppBarTheme.color,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(bottomMenuList.length, (index) {
                final menu = bottomMenuList[index];
                return Expanded(
                  flex: index == selectedIndex ? 0 : 1,
                  child: GestureDetector(
                    onTap: () {
                      _onTabSelected(index);
                      //  widget.onChanged?.call(bottomMenuList[index].type);
                    },
                    child: _buildIcon(
                      menu,
                      isActive: index == selectedIndex,
                      theme: theme,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(
    BottomMenuModel menu, {
    required bool isActive,
    required ThemeData theme,
  }) {
    return isActive
        ? Container(
          decoration: BoxDecoration(
            color: theme.primaryColor, // Use the theme's primary color
            borderRadius: BorderRadius.circular(18), // Rounded corners
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: 6.0,
          ), // Outer spacing
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 6.0,
          ), // Inner spacing
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              menu.isProfile
                  ? CircleAvatar(
                    radius: 13,
                    backgroundImage:
                        menu.activeIcon.startsWith('http')
                            ? NetworkImage(menu.activeIcon)
                            : AssetImage(menu.activeIcon),
                  )
                  : CustomImageView(
                    imagePath: menu.activeIcon,
                    height: 24,
                    width: 24,
                    //   color: Colors.white, // Active icon color
                  ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  menu.title ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
        : Center(
          child:
              menu.isProfile
                  ? CircleAvatar(
                    radius: 13,
                    backgroundImage:
                        menu.icon.startsWith('http')
                            ? NetworkImage(menu.icon)
                            : AssetImage(menu.icon),
                  )
                  : CustomImageView(
                    imagePath: menu.icon,
                    height: 24,
                    width: 24,

                    color:
                        menu.type == BottomBarEnum.Profile
                            ? null
                            : theme.iconTheme.color,
                    //   color: theme.iconTheme.color, // Inactive color
                  ),
        );
  }
}

class BottomMenuModel {
  final String icon;
  final String activeIcon;
  final String? title;
  final BottomBarEnum type;
  final bool isProfile;

  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
    required this.isProfile,
  });
}
