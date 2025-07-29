import 'package:get/get.dart';
import 'package:xm_frontend/features/authentication/screens/forgot_password/forgot_password.dart';

import 'package:xm_frontend/features/authentication/screens/invitation/invitation.dart';
import 'package:xm_frontend/features/authentication/screens/login/login.dart';
import 'package:xm_frontend/features/authentication/screens/register/register.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/bookings_requests/bookings_requests.dart';
import 'package:xm_frontend/features/shop/screens/building/all_buildings/buildings.dart';
import 'package:xm_frontend/features/shop/screens/building/edit_building/edit_building.dart';
import 'package:xm_frontend/features/shop/screens/building/unit_detail/unit_detail.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/communications.dart';
import 'package:xm_frontend/features/shop/screens/contract/contract_detail.dart';
import 'package:xm_frontend/features/shop/screens/dashboard/dashboard.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/settings_management.dart';
import 'package:xm_frontend/features/shop/screens/tenant/tenant_detail.dart';
import 'package:xm_frontend/features/shop/screens/tenants_contracts/tenants_contracts.dart';
import 'package:xm_frontend/presentation/screens/splash_screen/splash_screen.dart';

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

    // buildings & units
    GetPage(
      name: Routes.buildingsUnits,
      page: () => BuildingsScreen(),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.editBuilding,
      page: () => EditBuildingScreen(),
      binding: BindingsBuilder(() {
        Get.delete<
          EditBuildingController
        >(); //  ensures previous instance is removed
        Get.put(EditBuildingController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.unitDetails,
      page: () => UnitDetailScreen(),
      binding: BindingsBuilder(() {
        Get.delete<
          BuildingUnitDetailController
        >(); //  ensures previous instance is removed
        Get.put(BuildingUnitDetailController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.contractDetails,
      page: () => ContractDetailScreen(),
      binding: BindingsBuilder(() {
        //  Get.delete<
        //    ContractController
        //   >(); //  ensures previous instance is removed
        Get.put(ContractController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.tenantDetails,
      page: () => TenantDetailScreen(),
      binding: BindingsBuilder(() {
        // Get.delete<TenantController>(); //  ensures previous instance is removed
        Get.put(TenantController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.tenantsContracts,
      page: () => TenantsContractsScreen(),

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
        // Get.put(UserController()); // fresh instance every time
      }),
      middlewares: [RouteMiddleware()],
    ),
  ];
}
