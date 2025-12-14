import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cartakers/data/api/services/object_service.dart';
import 'package:cartakers/data/models/object_model.dart';
import 'package:cartakers/data/models/unit_model.dart';

/// Repository class for user-related operations.
class UnitRepository extends GetxController {
  static UnitRepository get instance => Get.find();

  final _objectService = ObjectService();

  /// Function to save building data to database.
  Future<void> createObject(UnitModel nunit) async {}

  /// Function to fetch user details based on user ID.
  Future<ObjectModel> fetchObjectUnitDetails(String id) async {
    return ObjectModel.empty();
  }

  Future<bool> updateUnitStatus(int unitId, status) async {
    try {
      // first update the fields
      final result = await _objectService.updateUnitStatus(unitId, status);

      if (result['success'] == false) {
        debugPrint('Error updating unit status : ${result['message']}');
        return false;
      }

      debugPrint('Update unit status Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error updating unit status: $e');
      return false;
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {}

  /// Delete User Data
  Future<bool> deleteObjectUnit(String id) async {
    return false;
  }
}
