import 'package:get/get.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/data/repositories/unit/unit_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';

class BuildingUnitController extends TBaseController<UnitModel> {
  static BuildingUnitController get instance => Get.find();

  final _buildingRepository = Get.put(BuildingRepository());
  final Rx<UnitModel> unit = UnitModel.empty().obs;

  var totalVacantUnits = 0.obs;

  RxList<UnitModel> allUnits = <UnitModel>[].obs;
  RxList<UnitModel> allVacantUnits = <UnitModel>[].obs;

  final userController = Get.find<UserController>();

  BuildingUnitController();

  @override
  Future<List<UnitModel>> fetchItems() async {
    try {
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;
      //       final units = await _buildingRepository.fetchBuildingUnits(
      //   agencyId.toString(),
      // );
      final units = await _buildingRepository.fetchAgencyBuildingsUnits(
        agencyId.toString(),
      );

      final updatedUser = await userController.fetchUserDetails();

      final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredUnits =
          units
              .where(
                (unit) => userBuildingRestrictions.contains(
                  int.parse(unit.buildingId.toString()),
                ),
              )
              .toList();

      allUnits.assignAll(filteredUnits);
      allVacantUnits.assignAll(
        filteredUnits.where((u) => u.statusId == 1).toList(),
      );
      totalVacantUnits.value = allVacantUnits.length;
      return filteredUnits;
    } catch (e) {
      rethrow;
    }
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (UnitModel o) => o.unitNumber.toString().toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(UnitModel item, String query) {
    return item.unitNumber!.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(UnitModel item) async {
    return false;
  }
}
