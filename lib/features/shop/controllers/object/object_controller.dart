import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';

class ObjectController extends TBaseController<ObjectModel> {
  RxList<ObjectModel> allObjects = <ObjectModel>[].obs;
  RxList<ObjectModel> filteredObjects = <ObjectModel>[].obs;
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

    //debugPrint('Updated objecs in controller: ${result }');

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];
    

    // Normalize both lists to String for comparison
    final restrictionIds = userObjectRestrictions.map((e) => e.toString()).toSet();
    

    // Debug print each object's imgUrl 
    /*
    for (var object in result) {
      debugPrint('Object: ${object.name}, imgUrl: ${object.imgUrl}');
    }
    *//*
    final filteredItems = result.where((object) {
      final objectIdStr = object.id.toString();
      return restrictionIds.contains(objectIdStr);
    }).toList();
*/
    allItems.assignAll(result);
    allObjects.assignAll(result);
    filteredObjects.assignAll(result);
    filteredItems.assignAll(result);
    selectedRows.value = List<bool>.filled(filteredItems.length, false);
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

    final filteredItems =
        result
            .where(
              (object) => userObjectRestrictions.contains(
                int.parse(object.id.toString()),
              ),
            )
            .toList();

    debugPrint('Filtered objects: ${filteredItems.length}');

    return filteredItems;
  }
  void filterItemsWithSearch([String query = '']) {
    // print(
    //   "Filtering users with selectedRoleFilterId.value = ${selectedRoleFilterId.value}",
    // );
    // allItems.forEach((item) {
    //   print("User: ${item.firstName} ${item.lastName}, roleId: ${item.roleId}");
    // });

    final results =
        allItems.where((item) {
          // 1. Search query: allow empty (show all)
          final matchesSearch =
              query.isEmpty || containsSearchQuery(item, query);


          return matchesSearch;
        }).toList();

    filteredItems.assignAll(results);
    debugPrint('Filtering objects: found ${results.length} results for "$query"');


  selectedRows.value = List<bool>.filled(filteredItems.length, false); // <-- Add 
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
      final containerName = 'docs';
      final directory = 'objects/${item.id}';

      await _objectRepository.deleteObjectDirectory(
        containerName,
        directory,
      );
      // Reload objects after deletion
      await loadAllObjects();
    }

    return isDeleted;
  }
}
