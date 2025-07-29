import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/amenity_zone_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/models/amenity_zone_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

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

  RxInt buildingId = 0.obs; // Building ID to be set externally

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
        await BuildingRepository.instance.getZonesForBuilding(
          buildingId.value.toString(),
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
        await BuildingRepository.instance.getZonesForBuilding(
          buildingId.value.toString(),
        ),
      );

      debugPrint(
        'Loaded ${zones.length} zones for building ${buildingId.value}',
      );

      // Load all units with their current zone assignments (may include null zone_id)
      final allAssignments = await BuildingRepository.instance
          .getZoneAssignments(buildingId.value.toString());

      // Convert assignments to UnitModel
      final allUnits =
          allAssignments.map((e) {
            return UnitModel(
              id: e.unitId.toString(),
              unitNumber: e.unitNumber,
              floorNumber: e.unitNumber?.substring(
                0,
                e.unitNumber!.length == 4 ? 2 : 1,
              ),
            );
          }).toList();

      units.assignAll(allUnits);
      filteredUnits.assignAll(allUnits);

      //  Initialize zoneSelections for all zones
      for (final z in zones) {
        final assigned =
            allAssignments
                .where((e) => e.zoneId == z.id)
                .map((e) => e.unitId)
                .toSet();
        zoneSelections[z.id] = assigned;
      }

      // Set selected zone and current visible units
      if (zones.isNotEmpty) {
        selectedZoneId.value = zones.first.id;
        selectedUnitIds.assignAll(zoneSelections[selectedZoneId.value!] ?? {});
      }
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
    } else {
      // Otherwise fetch from DB
      final allAssignments = await BuildingRepository.instance
          .getZoneAssignments(buildingId.value.toString());
      final assignedToZone = allAssignments
          .where((entry) => entry.zoneId == zoneId)
          .map((entry) => entry.unitId);

      selectedUnitIds.assignAll(assignedToZone);
    }
  }

  Future<void> loadZoneAssignments() async {
    if (selectedZoneId.value == null) return;
    selectedUnitIds.clear();

    final assignedData = await BuildingRepository.instance.getZoneAssignments(
      buildingId.value.toString(),
    );
    selectedUnitIds.addAll(
      assignedData
          .where((entry) => entry.zoneId == selectedZoneId.value)
          .map((entry) => entry.unitId),
    );
  }

  Future<void> fetchAssignedUnits() async {
    selectedUnitIds.clear();
    if (selectedZoneId.value != null) {
      final assignments = await BuildingRepository.instance.getZoneAssignments(
        buildingId.value.toString(),
      );
      selectedUnitIds.addAll(
        assignments
            .where((e) => e.zoneId == selectedZoneId.value)
            .map((e) => e.unitId),
      );
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

    final assigned = await BuildingRepository.instance.getZoneAssignments(
      buildingId.value.toString(),
    );

    selectedUnitIds.addAll(
      assigned
          .where((a) => a.zoneId == selectedZoneId.value)
          .map((a) => a.unitId),
    );
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

      final result = await BuildingRepository.instance.assignUnitsBatch(
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

    final result = await BuildingRepository.instance.createAmenityZone(
      buildingId.value,
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
