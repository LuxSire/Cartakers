import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/agency/agency_repository.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/data/repositories/contract/contract_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/helper_functions.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final RxList<double> weeklySales = <double>[].obs;

  var totalAgencyBuildings = 0.obs;
  var totalBuildingsTenants = 0.obs;
  var totalBuildingsContracts = 0.obs;
  var totalBuildingsPendingRequests = 0.obs;
  var totalBuildingsBookings = 0.obs;
  var totalBuildingsRequests = 0.obs;
  var totalBuildingsOpenedTasks = 0.obs;
  var totalBuildingsVacantUnits = 0.obs;
  var totalBuildingsMessages = 0.obs;

  Rx<UserModel> userRetrived = UserModel.empty().obs;

  ///
  @override
  void onInit() {
    super.onInit();
  }

  /// Call this from your Dashboard screen manually
  Future<void> initDashboardTotals() async {
    final userController = Get.find<UserController>();

    // Load user details
    await userController.fetchUserDetailsById(
      int.parse(AuthenticationRepository.instance.currentUser!.id.toString()),
    );

    userRetrived.value = userController.user.value;

    await fetchTotalBuildings();
    await fetchTotalTenants();
    await fetchTotalPendingRequests();
    await fetchTotalVacantUnits();
    await fetchTotalContracts();
    await fetchTotalBookings();
    await fetchTotalBuildingsMessages();
  }

  Future<void> fetchTotalBuildingsMessages() async {
    final result = await AgencyRepository.instance.fetchAllAgencyMessages();

    // Get allowed building IDs for the user
    final user = userRetrived.value;

    final userBuildingRestrictions = user.buildingPermissionIds ?? [];

    final filteredMessages =
        result.where((message) {
          final buildingIds = message.buildingIds ?? [];
          return buildingIds.any((id) => userBuildingRestrictions.contains(id));
        }).toList();

    // debugPrint('User Building Restrictions: $userBuildingRestrictions');
    // filteredMessages.forEach(
    //   (msg) =>
    //       debugPrint('Message ID: ${msg.id}, buildingIds: ${msg.buildingIds}'),
    // );

    totalBuildingsMessages.value = filteredMessages.length;
  }

  Future<void> fetchTotalBuildings() async {
    final result = await BuildingRepository.instance.getAllBuildings();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final buildingPermissionIds = user.buildingPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredBuildings =
        result
            .where(
              (building) => buildingPermissionIds.contains(
                int.parse(building.id.toString()),
              ),
            )
            .toList();

    totalAgencyBuildings.value = filteredBuildings.length;
  }

  Future<void> fetchTotalTenants() async {
    final result = await UserRepository.instance.getAllAgencyBuildingTenants();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final buildingPermissionIds = user.buildingPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredTenants =
        result
            .where(
              (tenant) => buildingPermissionIds.contains(
                int.parse(tenant.buildingId.toString()),
              ),
            )
            .toList();

    totalBuildingsTenants.value = filteredTenants.length;
  }

  Future<void> fetchTotalBookings() async {
    final result =
        await BuildingRepository.instance.fetchBuildingsBookingsByAgencyId();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final buildingPermissionIds = user.buildingPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredBookings =
        result
            .where(
              (booking) => buildingPermissionIds.contains(
                int.parse(booking.buildingId.toString()),
              ),
            )
            .toList();

    totalBuildingsBookings.value = filteredBookings.length;
  }

  Future<void> fetchTotalContracts() async {
    final controller = Get.put(ContractRepository());

    final result = await controller.getAllAgencyBuildingsContracts();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final buildingPermissionIds = user.buildingPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredContracts =
        result
            .where(
              (contract) => buildingPermissionIds.contains(
                int.parse(contract.buildingId.toString()),
              ),
            )
            .toList();

    totalBuildingsContracts.value = filteredContracts.length;
  }

  Future<void> fetchTotalPendingRequests() async {
    final requests =
        await BuildingRepository.instance.fetchBuildingsRequestsByAgencyId();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final buildingPermissionIds = user.buildingPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredRequests =
        requests
            .where(
              (request) => buildingPermissionIds.contains(
                int.parse(request.buildingId.toString()),
              ),
            )
            .toList();

    totalBuildingsRequests.value = filteredRequests.length;
    totalBuildingsPendingRequests.value =
        filteredRequests.where((r) => r.status == 1).length;
  }

  Future<void> fetchTotalVacantUnits() async {
    final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;
    final units = await BuildingRepository.instance.fetchAgencyBuildingsUnits(
      agencyId.toString(),
    );

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final buildingPermissionIds = user.buildingPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredUnits =
        units
            .where(
              (unit) => buildingPermissionIds.contains(
                int.parse(unit.buildingId.toString()),
              ),
            )
            .toList();

    totalBuildingsVacantUnits.value =
        filteredUnits.where((u) => u.statusId == 1).length;
  }
}
