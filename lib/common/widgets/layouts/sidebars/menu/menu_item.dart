import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';
import 'package:url_launcher/link.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../sidebar_controller.dart';

// class TMenuItem extends StatelessWidget {
//   const TMenuItem({super.key, required this.route, required this.itemName, required this.icon});

//   final String route;
//   final IconData icon;
//   final String itemName;

//   @override
//   Widget build(BuildContext context) {
//     final menuController = Get.put(SidebarController());
//     return Link(
//       uri: route != 'logout' ? Uri.parse(route) : null,
//       builder: (_, __) => InkWell(
//         onTap: () => menuController.menuOnTap(route),
//         onHover: (value) => value ? menuController.changeHoverItem(route) : menuController.changeHoverItem(''),
//         child: Obx(() {
//           // Decoration Box
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: menuController.isHovering(route) || menuController.isActive(route)
//                     ? TColors.primary
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
//               ),

//               // Icon and Text Row
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Icon
//                   Padding(
//                     padding: const EdgeInsets.only(left: TSizes.lg, top: TSizes.md, bottom: TSizes.md, right: TSizes.md),
//                     child: menuController.isActive(route)
//                         ? Icon(icon, size: 22, color: TColors.white)
//                         : Icon(icon, size: 22, color: menuController.isHovering(route) ? TColors.white : TColors.darkGrey),
//                   ),
//                   // Text
//                   if (menuController.isHovering(route) || menuController.isActive(route))
//                     Flexible(
//                       child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white)),
//                     )
//                   else
//                     Flexible(
//                       child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.darkGrey)),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

class TMenuItem extends StatelessWidget {
  const TMenuItem({
    super.key,
    required this.route,
    required this.itemName,
    required this.icon,
  });

  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());

    return InkWell(
      onTap: () {
        debugPrint('Menu item tapped: $route');
        if (route == '/tasks') {
          TLoaders.successSnackBar(
            title: AppLocalization.of(context).translate('general_msgs.msg_info'),
            message: AppLocalization.of(context).translate('general_msgs.msg_new_feature_coming_soon'),
          );
        } else {
          menuController.menuOnTap(route);
        }
      },
      onHover: (value) =>
          value ? menuController.changeHoverItem(route) : menuController.changeHoverItem(''),
      child: Obx(() {
        final isActive = menuController.isActive(route);
        final isHovering = menuController.isHovering(route);
        final isSelected = isActive || isHovering;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: TSizes.lg,
                    top: TSizes.md,
                    bottom: TSizes.md,
                    right: TSizes.md,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
                Flexible(
                  child: Text(
                    itemName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}