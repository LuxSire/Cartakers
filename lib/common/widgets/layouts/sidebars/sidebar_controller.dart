import 'package:get/get.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/popups/loaders.dart';

/// Controller for managing the sidebar state and functionality
class SidebarController extends GetxController {
  /// Instance of SidebarController
  static SidebarController instance = Get.find();

  /// Observable variable to track the active menu item
  final activeItem = Routes.dashboard.obs;

  /// Observable variable to track the menu item being hovered over
  final hoverItem = ''.obs;

  /// Change the active menu item
  void changeActiveItem(String route) => activeItem.value = route;

  /// Change the menu item being hovered over
  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  /// Check if a route is the active menu item
  bool isActive(String route) => activeItem.value == route;

  /// Check if a route is being hovered over
  bool isHovering(String route) => hoverItem.value == route;

  /// Handler for menu item tap
  Future<void> menuOnTap(String route) async {
    try {
      if (!isActive(route)) {
        changeActiveItem(route);

        //  Close drawer if on mobile
        if (TDeviceUtils.isMobileScreen(Get.context!)) Get.back();

        //  Handle Logout
        if (route == 'logout') {
          await AuthenticationRepository.instance.logout();
        } else {
          // 🧹 Reset specific controllers for certain routes
          if (route == Routes.objectsUnits) {
            Get.delete<ObjectUnitDetailController>();
            // Optionally delete others like EditBuildingController
          }

          if (route == Routes.usersContracts) {
            // Get.delete<TenantsController>();
          }

          // ✈ Navigate after cleanup
          // Get.toNamed(route);
          Get.offNamed(route);
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
