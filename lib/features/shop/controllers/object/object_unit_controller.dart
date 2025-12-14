import 'package:get/get.dart';
import 'package:cartakers/data/abstract/base_data_table_controller.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/data/repositories/unit/unit_repository.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';

class ObjectUnitController extends TBaseController<UnitModel> {
  static ObjectUnitController get instance => Get.find();

  final _objectRepository = Get.put(ObjectRepository());
  final Rx<UnitModel> unit = UnitModel.empty().obs;

  var totalVacantUnits = 0.obs;

  RxList<UnitModel> allUnits = <UnitModel>[].obs;
  RxList<UnitModel> allVacantUnits = <UnitModel>[].obs;

  final userController = Get.find<UserController>();

  ObjectUnitController();

  @override
  Future<List<UnitModel>> fetchItems() async {
    try {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;
      //       final units = await _objectRepository.fetchObjectUnits(
      //   agencyId.toString(),
      // );
      final units = await _objectRepository.fetchCompanyObjectsUnits(
        companyId.toString(),
      );

      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredUnits =
          units
              .where(
                (unit) => userObjectRestrictions.contains(
                  int.parse(unit.objectId.toString()),
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
