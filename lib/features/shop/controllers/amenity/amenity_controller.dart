import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/models/amenity_zone_model.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/data/models/amenity_zone_model.dart';
import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/utils/popups/loaders.dart';

class AmenityAssignmentController extends GetxController {
  static AmenityAssignmentController get instance => Get.find();

  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final amenityZoneNameController = TextEditingController();

  final loading = false.obs;
  final selectedZoneId = RxnInt();
  final zones = <AmenityZoneModel>[].obs;
  final units = <UnitModel>[].obs;
  final selectedUnitIds = <int>{}.obs;
  final allUnits = <UnitModel>[].obs;
  final filteredUnits = <UnitModel>[].obs;
  final Map<int, Set<int>> zoneSelections = {};

  RxInt objectId = 0.obs; // Object ID to be set externally

  AmenityAssignmentController();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadZones() async {
    try {
      loading.value = true;
      zones.clear();
      selectedZoneId.value = null;

      // Load zones
      zones.assignAll(
        await ObjectRepository.instance.getZonesForObject(
          objectId.value.toString(),
        ),
      );

      // Set selected zone
      if (zones.isNotEmpty) {
        selectedZoneId.value = zones.first.id;
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadData() async {
    try {
      loading.value = true;
      zones.clear();
      units.clear();
      selectedUnitIds.clear();
      filteredUnits.clear();
      zoneSelections.clear();

      // Load zones
      selectedZoneId.value = null;
      zones.assignAll(
        await ObjectRepository.instance.getZonesForObject(
          objectId.value.toString(),
        ),
      );

      debugPrint(
        'Loaded ${zones.length} zones for object ${objectId.value}',
      );


    } finally {
      loading.value = false;
    }
  }

  Future<void> setSelectedZone(int zoneId) async {
    // Save current zone selection before switching
    if (selectedZoneId.value != null) {
      zoneSelections[selectedZoneId.value!] = {...selectedUnitIds};
    }

    selectedZoneId.value = zoneId;

    // Restore from memory if available
    if (zoneSelections.containsKey(zoneId)) {
      selectedUnitIds.assignAll(zoneSelections[zoneId]!);
    } 
  }




  void filterUnits(String query) {
    if (query.isEmpty) {
      filteredUnits.assignAll(units); // NOT allUnits
    } else {
      filteredUnits.assignAll(
        units.where(
          (unit) =>
              unit.unitNumber?.toLowerCase().contains(query.toLowerCase()) ??
              false,
        ),
      );
    }
  }

  // Map<int, List<UnitModel>> getUnitsGroupedByFloor() {
  //   final map = <int, List<UnitModel>>{};
  //   for (var unit in filteredUnits) {
  //     final floor = int.tryParse(unit.floorNumber ?? '0') ?? 0;
  //     map.putIfAbsent(floor, () => []).add(unit);
  //   }
  //   return map;
  // }

  Map<int, List<UnitModel>> getUnitsGroupedByFloor() {
    final map = <int, List<UnitModel>>{};

    for (var unit in filteredUnits) {
      final unitNum = int.tryParse(unit.unitNumber ?? '') ?? 0;
      if (unitNum == 0) continue;

      final floor = unitNum ~/ 100;

      map.putIfAbsent(floor, () => []).add(unit);
    }

    // Sort floors
    final sortedKeys = map.keys.toList()..sort();
    return {for (var k in sortedKeys) k: map[k]!};
  }

  Future<void> refreshUnitSelections() async {
    selectedUnitIds.clear();


  }

  void toggleUnit(int unitId) {
    if (selectedZoneId.value == null) return;

    final zoneId = selectedZoneId.value!;
    final zoneSet = zoneSelections.putIfAbsent(zoneId, () => <int>{});

    if (zoneSet.contains(unitId)) {
      zoneSet.remove(unitId);
      selectedUnitIds.remove(unitId);
    } else {
      zoneSet.add(unitId);
      selectedUnitIds.add(unitId);
    }

    selectedUnitIds.refresh();
  }

  Map<int, List<UnitModel>> get groupedUnitsByFloor {
    final Map<int, List<UnitModel>> grouped = {};
    for (var unit in units) {
      if (!grouped.containsKey(int.parse(unit.floorNumber!))) {
        grouped[int.parse(unit.floorNumber!)] = [];
      }
      grouped[int.parse(unit.floorNumber!)]!.add(unit);
    }
    return grouped;
  }

  // Future<bool> assignUnitsToZone() async {
  //   try {
  //     loading.value = true;

  //     for (final entry in zoneSelections.entries) {
  //       final zoneId = entry.key;
  //       final unitIds = entry.value.toList();

  //       debugPrint('Assigning Zone ID: $zoneId -> Units: $unitIds');

  //       await BuildingRepository.instance.assignUnitsToZone(
  //         zoneId: zoneId,
  //         unitIds: unitIds,
  //       );
  //     }

  //     TLoaders.successSnackBar(
  //       title: 'Success',
  //       message: 'Amenity zones updated!',
  //     );
  //     return true;
  //   } catch (e) {
  //     TLoaders.errorSnackBar(title: 'Error', message: e.toString());
  //     return false;
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  Future<bool> assignUnitsToZone() async {
    try {
      loading.value = true;

      final assignments =
          zoneSelections.entries.map((entry) {
            return {'zone_id': entry.key, 'unit_ids': entry.value.toList()};
          }).toList();

      final result = await ObjectRepository.instance.assignUnitsBatch(
        assignments,
      );

      if (result) {
        Get.back(result: true);

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_failed'),
        );
      }

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> submitNewAmenityZone() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    // Create a new amenity

    final result = await ObjectRepository.instance.createAmenityZone(
      objectId.value,
      amenityZoneNameController.text.trim(),
    );
    loading.value = false;

    if (result) {
      Get.back(result: true); //  Return `true` to indicate amenity  was created

      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_info'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_submitted'),
      );
    } else {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_data_failed_to_add'),
      );
    }
  }

  void resetSelections() {
    selectedUnitIds.clear();
    zoneSelections.clear();
  }

  void resetFields() {
    amenityZoneNameController.clear();
  }
}
