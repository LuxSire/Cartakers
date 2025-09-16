import 'package:get/get.dart';
import 'package:xm_frontend/features/authentication/screens/forgot_password/forgot_password.dart';

import 'package:xm_frontend/features/authentication/screens/invitation/invitation.dart';
import 'package:xm_frontend/features/authentication/screens/login/login.dart';
import 'package:xm_frontend/features/authentication/screens/register/register.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/bookings_requests.dart';
import 'package:xm_frontend/features/shop/screens/object/all_objects/objects.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/edit_object.dart';
import 'package:xm_frontend/features/shop/screens/object/unit_detail/unit_detail.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/communications.dart';
import 'package:xm_frontend/features/shop/screens/contract/permission_detail.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/dashboard.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/settings_management.dart';
import 'package:xm_frontend/features/shop/screens/user/user_detail.dart';
import 'package:xm_frontend/features/shop/screens/users_permissions/users_permissions.dart';
import 'package:xm_frontend/presentation/screens/splash_screen/splash_screen.dart';
import 'package:xm_frontend/features/authentication/screens/plans/plans.dart';
import 'package:xm_frontend/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/routes/routes_middleware.dart';

class AppRoute {
  static final List<GetPage> pages = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),

    GetPage(name: Routes.invitation, page: () => const InvitationScreen()),

    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(name: Routes.registerAdmin, page: () => RegisterScreen()),

    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardScreen(),
      middlewares: [RouteMiddleware()],
    ),

    // objects & units
    GetPage(
      name: Routes.objectsUnits,
      page: () => ObjectsScreen(),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.editObject,
      page: () => EditObjectScreen(),
      binding: BindingsBuilder(() {
        Get.delete<
          EditObjectController
        >(); //  ensures previous instance is removed
        Get.put(EditObjectController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

GetPage(
  name: Routes.plans,
  page: () => DesktopLayout(body: const PlansScreen()),
),
    GetPage(
      name: Routes.unitDetails,
      page: () => UnitDetailScreen(),
      binding: BindingsBuilder(() {
        Get.delete<
          ObjectUnitDetailController
        >(); //  ensures previous instance is removed
        Get.put(ObjectUnitDetailController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.permissionDetails,
      page: () => PermissionDetailScreen(),
      binding: BindingsBuilder(() {
        //  Get.delete<
        //    ContractController
        //   >(); //  ensures previous instance is removed
        Get.put(PermissionController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.userDetails,
      page: () => UserDetailScreen(),
      binding: BindingsBuilder(() {
        // Get.delete<TenantController>(); //  ensures previous instance is removed
        Get.find<UserController>(); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.usersPermissions,
      page: () => UsersPermissionsScreen(),

      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.bookingsRequests,
      page: () => BookingsRequestsScreen(),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.communication,
      page: () => CommunicationScreen(),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.settingsManagement,
      page: () => SettingsManagementScreen(),
      binding: BindingsBuilder(() {
        // Get.delete<UserController>(); //  ensures previous instance is removed
      }),
      middlewares: [RouteMiddleware()],
    ),
  ];
}
