import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:xm_frontend/data/api/services/building_service.dart';
import 'package:xm_frontend/data/models/amenity_unit_model.dart';
import 'package:xm_frontend/data/models/amenity_zone_model.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/booking_timeslot_model.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/data/models/category_model.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/organization_model.dart';
import 'package:xm_frontend/data/models/request_log_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/request_type_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/models/unit_room_model.dart';
import 'package:xm_frontend/data/models/unit_zone_assigment_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/building/edit_building_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Repository class for user-related operations.
class BuildingRepository extends GetxController {
  static BuildingRepository get instance => Get.find();

  final _buildingService = BuildingService();

  var totalBuildingTenants = 0.obs;

  /// Function to fetch all buildings from mysql.
  Future<List<BuildingModel>> getAllBuildings() async {
    try {
      // Assuming you already have access to the agencyId from somewhere (e.g. logged-in user)
      final agencyId = UserController.instance.user.value.agencyId;

      if (agencyId == null || agencyId.isEmpty) {
        debugPrint('Agency ID not found.');
        return [];
      }

      final response = await _buildingService.getBuildingsByAgencyId(
        int.parse(agencyId),
      );

      // get the user building restrictions

      totalBuildingTenants.value = response.length;

      return response
          .map((buildingData) => BuildingModel.fromJson(buildingData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching buildings: $e');
      return [];
    }
  }

  Future<List<OrganizationModel>> getAllMaintenanceServicers() async {
    try {
      // Assuming you already have access to the agencyId from somewhere (e.g. logged-in user)
      final agencyId = UserController.instance.user.value.agencyId;

      if (agencyId == null || agencyId.isEmpty) {
        debugPrint('Agency ID not found.');
        return [];
      }

      final response = await _buildingService.getMaintenanceServicers(
        int.parse(agencyId),
      );

      return response.map((data) => OrganizationModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all maintenance servicers: $e');
      return [];
    }
  }

  /// Function to fetch user details based on user ID.
  Future<BuildingModel> fetchBuildingDetails(String id) async {
    return BuildingModel.empty();
  }

  Future<List<UnitModel>> fetchBuildingUnits(String buildingId) async {
    //   debugPrint('Building ID: $buildingId');

    try {
      if (buildingId == null || buildingId.isEmpty) {
        debugPrint('Building ID not found.');
        return [];
      }

      final response = await _buildingService.getBuildingUnitsById(
        int.parse(buildingId),
      );

      return response.map((unitData) => UnitModel.fromJson(unitData)).toList();
    } catch (e) {
      debugPrint('Error fetching building units: $e');
      return [];
    }
  }

  Future<List<AmenityZoneModel>> getZonesForBuilding(String buildingId) async {
    try {
      if (buildingId == null || buildingId.isEmpty) {
        debugPrint('Building ID not found.');
        return [];
      }

      final response = await _buildingService.getZonesForBuilding(
        int.parse(buildingId),
      );

      return response
          .map((zoneData) => AmenityZoneModel.fromJson(zoneData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching building units: $e');
      return [];
    }
  }

  Future<List<UnitZoneAssignmentModel>> getZoneAssignments(
    String buildingId,
  ) async {
    try {
      if (buildingId.isEmpty) {
        debugPrint('Building ID not provided.');
        return [];
      }

      final response = await _buildingService.getZoneAssignmentsByBuildingId(
        int.parse(buildingId),
      );

      return response
          .map((assignment) => UnitZoneAssignmentModel.fromJson(assignment))
          .toList();
    } catch (e) {
      debugPrint('Error fetching zone assignments: $e');
      return [];
    }
  }

  Future<List<ContractModel>> fetchBuildingUnitContracts(String unitId) async {
    //   debugPrint('Building ID: $buildingId');

    try {
      if (unitId == null || unitId.isEmpty) {
        debugPrint('Unit ID not found.');
        return [];
      }

      final response = await _buildingService.getBuildingUnitContractsByUnitId(
        int.parse(unitId),
      );

      return response
          .map((unitData) => ContractModel.fromJson(unitData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching building unit contracts: $e');
      return [];
    }
  }

  /// Function to update user data in mysql.
  Future<bool> updateBuildingDetails(BuildingModel updatedBuilding) async {
    // display dehubprint of the updated building
    debugPrint('Updated Building: ${updatedBuilding.toJson()}');

    // get editcontroller instance
    final controller = Get.put(EditBuildingController());

    debugPrint(controller.hasImageChanged.value.toString());

    try {
      if (updatedBuilding.id == null || updatedBuilding.id!.isEmpty) {
        debugPrint('Building ID not found.');
        return false;
      }

      // first check if image has changed or been updated

      String imageUrl = updatedBuilding.imgUrl ?? '';

      // if (controller.hasImageChanged.value == true) {
      //   try {
      //     final directoryName =
      //         "agencies/${updatedBuilding.agencyId}/buildings/${updatedBuilding.id}"; // Set the directory for storage

      //     final tempFile = await writeBytesToTempFile(
      //       controller.memoryBytes.value!,
      //       "building_${updatedBuilding.id}.jpg",
      //     );

      //     final imageResponse = await _buildingService.uploadAzureImage(
      //       file: tempFile,
      //       buildingId: int.parse(updatedBuilding.id!),
      //       containerName: "media",
      //       directoryName: directoryName,
      //     );

      //     if (imageResponse['success'] == false) {
      //       debugPrint("Failed to upload image: ${imageResponse['message']}");
      //     } else {
      //       final imageData = jsonDecode(imageResponse['data']);
      //       userImageUrl = imageData['url'];
      //       debugPrint("Image URL: $userImageUrl");
      //       updatedBuilding.imgUrl = userImageUrl;
      //     }
      //   } catch (error) {
      //     debugPrint("Error uploading image: $error");
      //   }
      // }

      if (controller.hasImageChanged.value) {
        final directoryName =
            "agencies/${updatedBuilding.agencyId}/buildings/${updatedBuilding.id}";

        try {
          late Map<String, dynamic> imageResponse;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          if (kIsWeb) {
            // WEB: upload directly from bytes
            // get datetime to add to filename
            //${DateTime.now().millisecondsSinceEpoch}

            final bytes = controller.memoryBytes.value!;
            final filename = "building_${updatedBuilding.id}_$timestamp.jpg";
            imageResponse = await _buildingService.uploadAzureImage(
              bytes: bytes,
              filename: filename,
              id: int.parse(updatedBuilding.id!),
              containerName: "media",
              directoryName: directoryName,
            );
          } else {
            // MOBILE/DESKTOP: write to temp file then upload
            final temp = await writeBytesToTempFile(
              controller.memoryBytes.value!,
              'building_${updatedBuilding.id}_$timestamp.jpg',
            );
            imageResponse = await _buildingService.uploadAzureImage(
              file: temp,
              filename: p.basename(temp.path),
              id: int.parse(updatedBuilding.id!),
              containerName: 'media',
              directoryName: directoryName,
            );
          }

          if (imageResponse['success'] != true) {
            debugPrint("Failed to upload image: ${imageResponse['message']}");
          } else {
            final data = jsonDecode(imageResponse['data']);
            final userImageUrl = data['url'] as String;
            debugPrint("Image URL: $userImageUrl");
            updatedBuilding.imgUrl = userImageUrl;
          }
        } catch (error) {
          debugPrint("Error uploading image: $error");
        }
      }

      // Update the building details

      debugPrint('User Image URL before updating: $imageUrl');

      final result = await _buildingService.updateBuildingDetails(
        int.parse(updatedBuilding.id!),
        updatedBuilding.name!,
        updatedBuilding.street!,
        updatedBuilding.buildingNumber!,
        updatedBuilding.zipCode!,
        updatedBuilding.location!,
        updatedBuilding.imgUrl ?? '',
      );

      if (result['success'] == false) {
        debugPrint('Error updating building: ${result['message']}');
        return false;
      }

      debugPrint('Update Building Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error updating building: $e');
      return false;
    }
  }

  Future<File> writeBytesToTempFile(Uint8List bytes, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = path.join(tempDir.path, filename);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {}

  /// Delete  Data
  Future<bool> deleteBuilding(int id) async {
    try {
      final response = await _buildingService.deleteBuildingById(id);

      if (response['success'] != true) {
        throw Exception('Failed to delete building: ${response['message']}');
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting building: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> deleteBuildingDirectory(String container, directory) async {
    try {
      final response = await _buildingService.deleteBuildingDirectory(
        container,
        directory,
      );

      if (response['status'] != 200) {
        throw Exception(
          'Failed to delete user directory: ${response['message']}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting user directory: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> assignUnitsToZone({
    required int zoneId,
    required List<int> unitIds,
  }) async {
    try {
      final response = await _buildingService.assignUnitsToZone(
        zoneId: zoneId,
        unitIds: unitIds,
      );

      if (response['success'] == false) {
        return false;
      }

      return true;
    } catch (error) {
      debugPrint("Error in assignUnitsToZone: $error");
      return false;
    }
  }

  Future<bool> assignUnitsBatch(List<Map<String, dynamic>> assignments) async {
    try {
      final response = await _buildingService.assignUnitsBatch(assignments);

      if (response['success'] == false) {
        return false;
      }

      return true;
    } catch (error) {
      debugPrint("Error in assignUnitsBatch: $error");
      return false;
    }
  }

  Future<bool> createAmenityZone(int buildingId, String amenityZoneName) async {
    try {
      final response = await _buildingService.createAmenityZone(
        buildingId,
        amenityZoneName,
      );

      if (response['success'] == false) {
        return false;
      }

      return true;
    } catch (error) {
      debugPrint("Error in createAmenityZone: $error");
      return false;
    }
  }

  Future<List<RequestLog>> fetchRequestLogsByRequestId(int requestId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _buildingService
          .getBuildingRequestLogs(requestId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestLog.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchRequestLogsByRequestId: $e');
      return [];
    }
  }

  Future<List<RequestTypeModel>> fetchRequestTypes(int buildingId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _buildingService
          .getBuildingRequestTypes(
            buildingId,
          ); // replace with selected building id

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestTypeModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchRequestTypes: $e');
      return [];
    }
  }

  Future<List<BookingModel>> fetchBuildingRecentBookingsByBuildingId(
    int buildingId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _buildingService
          .getBuildingRecentBookings(
            buildingId,
          ); // replace with selected building id

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchBuildingRecentBookingsByBuildingId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchBuildingRequestsByBuildingId(
    int buildingId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _buildingService
          .getBuildingAllRequests(buildingId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchBuildingRequestsByBuildingId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchBuildingsRequestsByAgencyId() async {
    final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;

    try {
      final List<Map<String, dynamic>> responseList = await _buildingService
          .getAgencyBuildingsAllRequests(int.parse(agencyId));

      if (responseList.isEmpty) return [];

      debugPrint('Response List: $responseList');

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchBuildingsRequestsByAgencyId: $e');
      return [];
    }
  }

  Future<List<BookingModel>> fetchBuildingsBookingsByAgencyId() async {
    try {
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;

      final List<Map<String, dynamic>> responseList = await _buildingService
          .getAgencyBuildingsAllBookings(int.parse(agencyId));

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchBuildingsBookingsByAgencyId: $e');
      return [];
    }
  }

  Future<bool> createBuilding(
    String buildingName,
    String street,
    String buildingNumber,
    String zipCode,
    String location,

    int totalUnits,
    int totalFloors,
  ) async {
    final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;
    try {
      final response = await _buildingService.createBuilding(
        int.parse(agencyId),
        buildingName,
        street,
        buildingNumber,
        zipCode,
        location,
        totalUnits,
        totalFloors,
      );

      debugPrint('Create Building Response: $response');

      if (response['success'] == false) {
        return false;
      }

      final buildingId = response['data'][0]['buildingId'];

      final users =
          await UserController.instance.fetchUsersAndTranslateFields();
      // filter only admins
      final adminUsers = users.where((user) => user.roleExtId == 1).toList();

      // add to building permissions
      final user = UserController.instance.user.value;

      // remove the user from the list of admins
      final filteredAdmins =
          adminUsers.where((admin) => admin.id != user.id).toList();
      // assign the user to the building permission
      await assignUserToBuildingPermission(buildingId, int.parse(user.id!));

      // also assign to all admins
      for (final admin in filteredAdmins) {
        await assignUserToBuildingPermission(buildingId, int.parse(admin.id!));
      }

      return true;
    } catch (error) {
      debugPrint("Error in createBuilding: $error");
      return false;
    }
  }

  Future<List<UnitModel>> fetchAgencyBuildingsUnits(String agencyId) async {
    //   debugPrint('Building ID: $buildingId');

    try {
      if (agencyId == null || agencyId.isEmpty) {
        debugPrint('Agency ID not found. fetchAgencyBuildingsUnits');
        return [];
      }

      final response = await _buildingService.getAgencyBuildingsUnitsById(
        int.parse(agencyId),
      );

      return response.map((unitData) => UnitModel.fromJson(unitData)).toList();
    } catch (e) {
      debugPrint('Error fetching agency building units: $e');
      return [];
    }
  }

  Future<List<UnitRoomModel>> fetchBuildingUnitsRoomList() async {
    try {
      final response = await _buildingService.getBuildingUnitRoomList();

      return response
          .map((unitData) => UnitRoomModel.fromJson(unitData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching building units room list: $e');
      return [];
    }
  }

  Future<bool> updateUnitRoom(int unitId, int roomId) async {
    try {
      final result = await _buildingService.updateBuildingUnitRoom(
        unitId,
        roomId, // pieceId is the room ID
      );

      if (result['success'] == false) {
        debugPrint('Error updating unit room : ${result['message']}');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error updating building unit room: $e');
      return false;
    }
  }

  Future<List<CategoryModel>> getAllAgencyAmenityCategories() async {
    try {
      final agencyId = UserController.instance.user.value.agencyId;

      if (agencyId == null || agencyId.isEmpty) {
        debugPrint('Agency ID not found.');
        return [];
      }

      final response = await _buildingService.getAllAgencyAmenityCategories(
        int.parse(agencyId),
      );

      return response.map((data) => CategoryModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching agency amenity categories: $e');
      return [];
    }
  }

  Future<List<AmenityUnitModel>> getTenantBuildingAvailableAmenityUnitsV2(
    int buildingId,
    int zoneId,
    int categoryId,
  ) async {
    try {
      debugPrint(
        'getTenantBuildingAvailableAmenityUnitsV2: buildingId: $buildingId, zoneId: $zoneId, categoryId: $categoryId',
      );

      final List<Map<String, dynamic>> responseList = await _buildingService
          .getTenantBuildingAvailableAmenityUnitsV2(
            buildingId,
            zoneId,
            categoryId,
          );

      if (responseList.isEmpty) return [];

      return responseList
          .map((data) => AmenityUnitModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error in getTenantBuildingAvailableAmenityUnitsV2: $e');
      return [];
    }
  }

  Future<List<BookingTimeslotModel>> getBuildingAmenityUnitAvailability(
    int amenityUnitId,
    DateTime bookingDate,
    int excludeBookingId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _buildingService
          .getBuildingAmenityUnitTimeSlots(
            amenityUnitId,
            bookingDate,
            excludeBookingId,
          );

      if (responseList.isEmpty) return [];

      return responseList
          .map((data) => BookingTimeslotModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error in getBuildingAmenityUnitAvailability: $e');
      return [];
    }
  }

  Future<bool> assignUserToBuildingPermission(
    int buildingId,
    int userId,
  ) async {
    try {
      final response = await _buildingService.assignUserToBuildingPermission(
        buildingId,
        userId,
      );

      if (response['success'] == false) {
        return false;
      }

      return true;
    } catch (error) {
      debugPrint("Error in assignUnitsToZone: $error");
      return false;
    }
  }
}
