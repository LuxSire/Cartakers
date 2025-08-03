import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';

class ObjectController extends TBaseController<ObjectModel> {
  static ObjectController get instance => Get.find();

  final _objectRepository = Get.put(ObjectRepository());

  final userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    loadAllObjects();
  }

  Future<void> loadAllObjects() async {
    final result = await _objectRepository.getAllObjects();

    // also get user object restrictions
    final updatedUser = await userController.fetchUserDetails();

    debugPrint('Updated User in controller: ${updatedUser.toJson()}');

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];
    

    // Normalize both lists to String for comparison
    final restrictionIds = userObjectRestrictions.map((e) => e.toString()).toSet();
    

    // Debug print each object's imgUrl 
    for (var object in result) {
      debugPrint('Object: ${object.name}, imgUrl: ${object.imgUrl}');
    }

    final filteredObjects = result.where((object) {
      final objectIdStr = object.id.toString();
      return restrictionIds.contains(objectIdStr);
    }).toList();


    filteredItems.value = filteredObjects;
    // debugPrint('Filtered buildings: ${filteredItems.length}');
  }

  @override
  Future<List<ObjectModel>> fetchItems() async {
    // debugPrint('Fetching buildings...');

    // filter by agencyId if needed

    final result = await _objectRepository.getAllObjects();

    // debugPrint('Loaded buildings: ${result.length}');

    // also get user building restrictions

    final updatedUser = await userController.fetchUserDetails();

    //  debugPrint('Updated User in controller: ${updatedUser.toJson()}');

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

    //  debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredObjects =
        result
            .where(
              (object) => userObjectRestrictions.contains(
                int.parse(object.id.toString()),
              ),
            )
            .toList();

    debugPrint('Filtered objects: ${filteredObjects.length}');

    return filteredObjects;
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ObjectModel b) => b.name.toString().toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(ObjectModel item, String query) {
    return item.name!.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(ObjectModel item) async {
    final isDeleted = await _objectRepository.deleteObject(
      int.parse(item.id.toString()),
    );

    if (isDeleted) {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;
      final containerName = 'media';
      final directory = 'companies/$companyId/objects/${item.id}';

      await _objectRepository.deleteObjectDirectory(
        containerName,
        directory,
      );
    }

    return isDeleted;
  }
}
