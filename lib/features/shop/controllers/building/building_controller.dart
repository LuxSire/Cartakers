import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';

class BuildingController extends TBaseController<BuildingModel> {
  static BuildingController get instance => Get.find();

  final _buildingRepository = Get.put(BuildingRepository());

  final userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    loadAllBuildings();
  }

  Future<void> loadAllBuildings() async {
    final result = await _buildingRepository.getAllBuildings();

    // also get user building restrictions

    final updatedUser = await userController.fetchUserDetails();

    debugPrint('Updated User in controller: ${updatedUser.toJson()}');

    final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

    debugPrint('User building restrictions: $userBuildingRestrictions');

    debugPrint('Loaded buildings: ${result.length}');

    final filteredBuildings =
        result
            .where(
              (building) => userBuildingRestrictions.contains(
                int.parse(building.id.toString()),
              ),
            )
            .toList();

    debugPrint('Filtered buildings: ${filteredBuildings.length}');

    filteredItems.value = filteredBuildings;

    // debugPrint('Filtered buildings: ${filteredItems.length}');
  }

  @override
  Future<List<BuildingModel>> fetchItems() async {
    // debugPrint('Fetching buildings...');

    // filter by agencyId if needed

    final result = await _buildingRepository.getAllBuildings();

    // debugPrint('Loaded buildings: ${result.length}');

    // also get user building restrictions

    final updatedUser = await userController.fetchUserDetails();

    //  debugPrint('Updated User in controller: ${updatedUser.toJson()}');

    final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

    //  debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredBuildings =
        result
            .where(
              (building) => userBuildingRestrictions.contains(
                int.parse(building.id.toString()),
              ),
            )
            .toList();

    debugPrint('Filtered buildings: ${filteredBuildings.length}');

    return filteredBuildings;
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (BuildingModel b) => b.name.toString().toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(BuildingModel item, String query) {
    return item.name!.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(BuildingModel item) async {
    final isDeleted = await _buildingRepository.deleteBuilding(
      int.parse(item.id.toString()),
    );

    if (isDeleted) {
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;
      final containerName = 'media';
      final directory = 'agencies/$agencyId/buildings/${item.id}';

      await _buildingRepository.deleteBuildingDirectory(
        containerName,
        directory,
      );
    }

    return isDeleted;
  }
}
