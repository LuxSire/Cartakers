import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/services/theme_service.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/app_controller.dart';
import 'package:cartakers/data/api/translation_api.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/utils/constants/enums.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../appbar/appbar.dart';
import '../../images/t_rounded_image.dart';
import '../../shimmers/shimmer.dart';

const _flagEmojis = {'de': '🇩🇪', 'fr': '🇫🇷', 'it': '🇮🇹', 'en': '🇬🇧'};

/// Header widget for the application
class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, required this.scaffoldKey});
 
  /// GlobalKey to access the Scaffold state
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final themeService = Get.find<ThemeService>();
    final userCtrl = UserController.instance;
    // grab your localization‐controlling AppController
    final appCtrl = Get.find<AppController>();
    // Obtain your ThemeService instance (adjust the type/class as needed)
    const langs = ['de', 'fr', 'it', 'en'];
    return Container(
      /// Background Color, Bottom Border
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: const Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      child: TAppBar(
        /// Mobile Menu
        leadingIcon:
            !TDeviceUtils.isDesktopScreen(context) ? Iconsax.menu : null,
        leadingOnPressed:
            !TDeviceUtils.isDesktopScreen(context)
                ? () => scaffoldKey.currentState?.openDrawer()
                : null,
        title: Row(
          children: [
            /// Search
            // if (TDeviceUtils.isDesktopScreen(context))
            //   SizedBox(
            //     width: 400,
            //     child: TextFormField(
            //       decoration: const InputDecoration(
            //         prefixIcon: Icon(Iconsax.search_normal),
            //         hintText: 'Search anything...',
            //       ),
            //     ),
            //   ),
          ],
        ),
        actions: [
          // Search Icon on Mobile
          // if (!TDeviceUtils.isDesktopScreen(context))
          //   IconButton(
          //     icon: const Icon(Iconsax.search_normal),
          //     onPressed: () {},
          //   ),

          // Notification Icon
          IconButton(icon: const Icon(Iconsax.notification), onPressed: () {}),
          const SizedBox(width: TSizes.spaceBtwItems / 2),
          
          /// User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
                         

            children: [
Obx(() => IconButton(
  icon: Icon(
    themeService.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
    color: Theme.of(context).iconTheme.color,
  ),
  tooltip: themeService.isDarkMode.value ? 'Switch to Light Mode' : 'Switch to Dark Mode',
  onPressed: () => themeService.toggleTheme(),
)),
              // add a drop down button for language selection

              // ── LANGUAGE DROPDOWN ───────────────────────
              DropdownButton<String>(
                value: appCtrl.locale.value.languageCode,
                underline: const SizedBox.shrink(),
                //   icon: const Icon(Icons.language, size: 20),
                items:
                    langs.map((code) {
                      final flag = _flagEmojis[code] ?? code.toUpperCase();
                      return DropdownMenuItem(
                        value: code,
                        child: Row(
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            Text(code.toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (newCode) {
                  if (newCode != null &&
                      newCode != appCtrl.locale.value.languageCode) {
                    appCtrl.changeLanguage(Locale(newCode));
                  }
                },
              ),
              const SizedBox(width: TSizes.sm),

              /// User Profile Image
              Obx(
                () => TRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  fit: BoxFit.cover,
                  imageType:
                      controller.user.value.profilePicture.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                  image:
                      controller.user.value.profilePicture.isNotEmpty
                          ? controller.user.value.profilePicture
                          : TImages.user,
                ),
              ),


const SizedBox(width: 8),
Obx(() {
  final category = controller.user.value.category;
  String badgeAsset;
  String tooltip;
  if (category == 'Premium') {
    badgeAsset = 'assets/images/img_premium.jpeg';
    tooltip = 'Premium Account';
    return Tooltip(
      message: tooltip,
      child: Image.asset(
        badgeAsset,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
      ),
    );
  } else if (category == 'Trial') {
    badgeAsset = 'assets/images/img_trial.jpeg';
    tooltip = 'Trial Account';
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          print('Current route: ${Get.currentRoute}');
          print('Context hash: ${context.hashCode}');

          Get.toNamed(Routes.plans);
        },
        child: Image.asset(
          badgeAsset,
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
    );
  } else {
    return const SizedBox.shrink();
  }
}),
              const SizedBox(width: TSizes.sm),

              /// User Profile Data [Hide on Mobile]
              if (!TDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const TShimmerEffect(width: 50, height: 13)
                          : Text(
                            controller.user.value.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                      controller.loading.value
                          ? const TShimmerEffect(width: 70, height: 13)
                          : Text(
                            controller.user.value.email,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
