import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/models/booking_model.dart';
import 'package:cartakers/data/models/request_model.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/data/repositories/company/company_repository.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/data/repositories/contract/permission_repository.dart';
import 'package:cartakers/data/repositories/user/user_repository.dart';
import 'package:cartakers/features/personalization/controllers/settings_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/booking/booking_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_unit_controller.dart';
import 'package:cartakers/features/shop/controllers/request/request_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/helper_functions.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final RxList<double> weeklySales = <double>[].obs;

  var totalCompanyObjects = 0.obs;
  var totalObjects=0.obs;
  var totalObjectsInNegotiation = 0.obs;
  var totalUsers = 0.obs;
  var totalObjectUsers=0.obs;
  var totalObjectsContracts = 0.obs;
  var totalObjectsPendingRequests = 0.obs;
  var totalObjectsBookings = 0.obs;
  var totalObjectsRequests = 0.obs;
  var totalObjectsOpenedTasks = 0.obs;
  var totalObjectsVacantUnits = 0.obs;
  var totalObjectsMessages = 0.obs;

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

    await fetchTotalObjects();
    await fetchTotalUsers();
    await fetchTotalObjectsInNegotiation();
    //await fetchTotalPendingRequests();
    //await fetchTotalVacantUnits();
    //await fetchTotalContracts();
    //await fetchTotalBookings();
    await fetchTotalObjectsMessages();
    //await fetchTotalObjectUsers();
  }

Future<void> fetchTotalObjectUsers() async {
  final result = await UserRepository.instance.getAllCompanyUsers();

  // Make sure user is loaded and not empty
  final user = userRetrived.value;
  final objectPermissionIds = user.objectPermissionIds ?? [];

  final filteredUsers = result.where(
    (user) => objectPermissionIds.contains(
      int.parse(user.objectId.toString()),
    ),
  ).toList();

  totalObjectUsers.value = filteredUsers.length;
}

  Future<void> fetchTotalObjectsMessages() async {
    final result = await ObjectRepository.instance.fetchAllMessages();

    // Get allowed object IDs for the user
    //final user = userRetrived.value;

    //final userObjectRestrictions = user.objectPermissionIds ?? [];

    final filteredMessages =result.toList( );

/*        result.where((message) {
          final objectIds = message.objectIds ?? [];
          return objectIds.any((id) => userObjectRestrictions.contains(id));
        }).toList();
*/
    // debugPrint('User Building Restrictions: $userBuildingRestrictions');
    // filteredMessages.forEach(
    //   (msg) =>
    //       debugPrint('Message ID: ${msg.id}, buildingIds: ${msg.buildingIds}'),
    // );

    totalObjectsMessages.value = filteredMessages.length;
  }

  Future<void> fetchTotalObjects() async {
    final result = await ObjectRepository.instance.getAllObjects();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final objectPermissionIds = user.objectPermissionIds ?? [];

    //debugPrint('User Object Restrictions: $objectPermissionIds');
  
    final _totalObjects =
        result.toList();

    totalObjects.value = _totalObjects.length;
  }

  Future<void> fetchTotalObjectsInNegotiation() async {
 
    final result = await ObjectRepository.instance.getAllObjects();
    // Make sure user is loaded and not empty
    final _totalObjects =
        result.toList();

    //debugPrint('User Object Restrictions: $objectPermissionIds');

    final _totalObjectsInNegotiation =
        _totalObjects.where((object) => object.status == 'In Negotiation').toList();

    totalObjectsInNegotiation.value = _totalObjectsInNegotiation.length;
  }


  Future<void> fetchTotalUsers() async {
    final result = await UserRepository.instance.getAllUsers();

    // Make sure user is loaded and not empty
    //final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    //final objectPermissionIds = user.objectPermissionIds ?? [];

    //debugPrint('User Object Restrictions: $objectPermissionIds');
  /*
    final filteredUsers =
        result
            .where(
              (user) => objectPermissionIds.contains(
                int.parse(user.id.toString()),
              ),
            )
            .toList();
  */
    totalUsers.value = result.length;
  }

  Future<void> fetchTotalBookings() async {
    final result =
        await ObjectRepository.instance.fetchObjectsBookingsByCompanyId();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final objectPermissionIds = user.objectPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredBookings =
        result
            .where(
              (booking) => objectPermissionIds.contains(
                int.parse(booking.objectId.toString()),
              ),
            )
            .toList();

    totalObjectsBookings.value = filteredBookings.length;
  }

  Future<void> fetchTotalContracts() async {
    final controller = Get.put(PermissionRepository());

    final result = await controller.getAllCompanyObjectsContracts();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final objectPermissionIds = user.objectPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredContracts =
        result
            .where(
              (contract) => objectPermissionIds.contains(
                int.parse(contract.objectId.toString()),
              ),
            )
            .toList();

    totalObjectsContracts.value = filteredContracts.length;
  }

  Future<void> fetchTotalPendingRequests() async {
    final requests =
        await ObjectRepository.instance.fetchObjectsRequestsByCompanyId();

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final objectPermissionIds = user.objectPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredRequests =
        requests
            .where(
              (request) => objectPermissionIds.contains(
                int.parse(request.objectId.toString()),
              ),
            )
            .toList();

    totalObjectsRequests.value = filteredRequests.length;
    totalObjectsPendingRequests.value =
        filteredRequests.where((r) => r.status == 1).length;
  }

  Future<void> fetchTotalVacantUnits() async {
    final companyId = AuthenticationRepository.instance.currentUser!.companyId;
    final units = await ObjectRepository.instance.fetchCompanyObjectsUnits(
      companyId.toString(),
    );

    // Make sure user is loaded and not empty
    final user = userRetrived.value;
    //   debugPrint('Current User: ${user.toJson()}');
    final objectPermissionIds = user.objectPermissionIds ?? [];

    //debugPrint('User Building Restrictions: $buildingPermissionIds');

    final filteredUnits =
        units
            .where(
              (unit) => objectPermissionIds.contains(
                int.parse(unit.objectId.toString()),
              ),
            )
            .toList();

    totalObjectsVacantUnits.value =
        filteredUnits.where((u) => u.statusId == 1).length;
  }
}
