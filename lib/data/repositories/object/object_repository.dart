import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:xm_frontend/data/api/services/object_service.dart';
import 'package:xm_frontend/data/models/amenity_unit_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
import 'package:xm_frontend/data/models/amenity_zone_model.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/booking_timeslot_model.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/category_model.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/data/models/organization_model.dart';
import 'package:xm_frontend/data/models/request_log_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/request_type_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/models/unit_room_model.dart';
import 'package:xm_frontend/data/models/unit_zone_assigment_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xm_frontend/data/repositories/media/media_repository.dart';
import 'package:path/path.dart' as p;

/// Repository class for user-related operations.
class ObjectRepository extends GetxController {
  /// Fetch all image URLs for an object from backend
  Future<List<DocsModel>> fetchObjectImages(int objectId) async {
    try {
      final response = await _objectService.fetchObjectImages( objectId);
      if (response == null ) {
        debugPrint('No images found for object $objectId');
        return [];
      }
      // Assuming response['data'] is a List<String> of URLs
      final images = response ?? [];
      debugPrint('Fetched images for object $objectId: ${images.length}');
      return images.map((doc) => DocsModel.fromJson(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching object images: $e');
      return [];
    }
  }
    Future<List<DocsModel>> fetchObjectDocs(int objectId) async {
    try {
      final response = await _objectService.fetchObjectDocs(objectId);
      if (response == null) {
        debugPrint('No documents found for object $objectId');
        return [];
      }
  
      return response.map((doc) => DocsModel.fromJson(doc)).toList();

    } catch (e) {
      debugPrint('Error fetching object docs: $e');
      return [];
    }
  }
  static ObjectRepository get instance => Get.find();

  final _objectService = ObjectService();

  var totalObjectUsers = 0.obs;

  /// Function to fetch all buildings from mysql.
  Future<List<ObjectModel>> getAllObjects() async {
    try {
      // Assuming you already have access to the companyId from somewhere (e.g. logged-in user)
      final response = await _objectService.getAllObjects();

      if (response.isEmpty) {
        debugPrint('No objects found.');
        return [];
      } else if (response is String) {
        debugPrint('Error fetching objects: $response');
        return [];
      } else {
        debugPrint('Fetched objects: ${response.length}');
      }

      totalObjectUsers.value = response.length;

      return response
          .map((objectData) => ObjectModel.fromJson(objectData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching objects: $e');
      return [];
    }
  }

  /// Function to fetch all buildings from mysql.
  Future<List<String>> getAllZonings() async {
    try {
      // Assuming you already have access to the companyId from somewhere (e.g. logged-in user)
      final response = await _objectService.getAllZonings();

      if (response.isEmpty) {
        debugPrint('No objects found.');
        return [];
      } else if (response is String) {
        debugPrint('Error fetching zonings: $response');
        return [];
      } else {
        debugPrint('Fetched zonings: ${response.length}');
      }
      return response.map((z) => z['name'].toString()).toList();
   
    } catch (e) {
      debugPrint('Error fetching zonings: $e');
      return [];
    }
  }

  /// Function to fetch all buildings from mysql.
  Future<List<String>> getAllOccupancies() async {
    try {
      // Assuming you already have access to the companyId from somewhere (e.g. logged-in user)
      final response = await _objectService.getAllOccupancies();

      if (response.isEmpty) {
        debugPrint('No objects found.');
        return [];
      } else if (response is String) {
        debugPrint('Error fetching occupancie§: $response');
        return [];
      } else {
        debugPrint('Fetched occupancie§: ${response.length}');
      }
      return response.map((z) => z['name'].toString()).toList();
   
    } catch (e) {
      debugPrint('Error fetching occupancie§: $e');
      return [];
    }
  }
    Future<List<String>> getAllTypes() async {
    try {
      // Assuming you already have access to the companyId from somewhere (e.g. logged-in user)
      final response = await _objectService.getAllTypes();

      if (response.isEmpty) {
        debugPrint('No objects found.');
        return [];
      } else if (response is String) {
        debugPrint('Error fetching types: $response');
        return [];
      } else {
        debugPrint('Fetched types: ${response.length}');
      }
      return response.map((z) => z['description'].toString()).toList();
   
    } catch (e) {
      debugPrint('Error fetching types: $e');
      return [];
    }
  }

    Future<List<CategoryModel>> getAllBookingCategories() async {
    try {
      // Assuming you already have access to the companyId from somewhere (e.g. logged-in user)
      final response = await _objectService.getAllBookingCategories();

      if (response.isEmpty) {
        debugPrint('No booking categories found.');
        return [];
      } else if (response is String) {
        debugPrint('Error fetching booking categories: $response');
        return [];  
      } else {
        debugPrint('Fetched booking categories: ${response.length}');
      }
     
      return response
          .map((categoryData) => CategoryModel.fromJson(categoryData))
          .toList();
   
    } catch (e) {
      debugPrint('Error fetching booking categories: $e');
      return [];
    }
  }
  Future<List<OrganizationModel>> getAllMaintenanceServicers() async {
    try {
      // Assuming you already have access to the agencyId from somewhere (e.g. logged-in user)
      final companyId = UserController.instance.user.value.companyId;

      if (companyId == null || companyId.isEmpty) {
        debugPrint('Company ID not found.');
        return [];
      }

      final response = await _objectService.getMaintenanceServicers(
        int.parse(companyId),
      );

      return response.map((data) => OrganizationModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all maintenance servicers: $e');
      return [];
    }
  }

  /// Function to fetch user details based on user ID.
  Future<ObjectModel> fetchObjectDetails(String id) async {
    return ObjectModel.empty();
  }

  Future<List<UnitModel>> fetchObjectUnits(int objectId) async {
    //   debugPrint('Building ID: $buildingId');

    try {
      if (objectId == null  ) {
        debugPrint('Object ID not found.');
        return [];
      }

      final response = await _objectService.getObjectUnitsById(
        objectId,
      );

      return response.map((unitData) => UnitModel.fromJson(unitData)).toList();
    } catch (e) {
      debugPrint('Error fetching object units: $e');
      return [];
    }
  }

  Future<List<AmenityZoneModel>> getZonesForObject(String objectId) async {
    try {
      if (objectId == null || objectId.isEmpty) {
        debugPrint('Object ID not found.');
        return [];
      }

      final response = await _objectService.getZonesForObject(
        int.parse(objectId),
      );

      return response
          .map((zoneData) => AmenityZoneModel.fromJson(zoneData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching building units: $e');
      return [];
    }
  }



  /// Function to update user data in mysql.
  Future<bool> updateObjectDetails(ObjectModel updatedObject) async {
    // display debugPrint of the updated object
    debugPrint('Updated Object: ${updatedObject.toJson()}');

    // get editcontroller instance
    final controller = Get.put(EditObjectController());

    debugPrint(controller.hasImageChanged.value.toString());

    try {
      if (updatedObject.id == null  ) {
        debugPrint('Object ID not found.');
        return false;
      }

      // first check if image has changed or been updated

      String imageUrl = updatedObject.imgUrl ?? '';

      // if (controller.hasImageChanged.value == true) {
      //   try {
      //     final directoryName =
      //         "agencies/${updatedObject.agencyId}/buildings/${updatedObject.id}"; // Set the directory for storage

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
            "objects/${updatedObject.id}";

        try {
          late Map<String, dynamic> imageResponse;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          if (kIsWeb) {
            // WEB: upload directly from bytes
            // get datetime to add to filename
            //${DateTime.now().millisecondsSinceEpoch}

            final bytes = controller.memoryBytes.value!;
            final filename = "object_${updatedObject.id}.jpg";
            imageResponse = await _objectService.uploadAzureImage(
              bytes: bytes,
              filename: filename,
              id: updatedObject.id!,
              containerName: "docs",
              directoryName: directoryName,
            );
          } else {
            // MOBILE/DESKTOP: write to temp file then upload
            final temp = await writeBytesToTempFile(
              controller.memoryBytes.value!,
              'object_${updatedObject.id}.jpg',
            );
            imageResponse = await _objectService.uploadAzureImage(
              file: temp,
              filename: p.basename(temp.path),
              id: updatedObject.id!,
              containerName: 'docs',
              directoryName: directoryName,
            );
          }

          if (imageResponse['success'] != true) {
            debugPrint("Failed to upload image: ${imageResponse['message']}");
          } else {
            final data = jsonDecode(imageResponse['data']);
            final userImageUrl = data['url'] as String;
            debugPrint("Image URL: $userImageUrl");
            updatedObject.imgUrl = userImageUrl;
          }
        } catch (error) {
          debugPrint("Error uploading image: $error");
        }
      }

      // Update the building details

      debugPrint('User Image URL before updating: $imageUrl');

      final result = await _objectService.updateObjectDetails(
        updatedObject.id!,
        updatedObject.name!,
        updatedObject.street!,
        updatedObject.zipCode!,
        updatedObject.location!,
        updatedObject.imgUrl ?? '',
        updatedObject.description ?? '',
      );

      if (result['success'] == false) {
        debugPrint('Error updating object: ${result['message']}');
        return false;
      }

      debugPrint('Update Object Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error updating object: $e');
      return false;
    }
  }

  /// Function to update user data in mysql.
  Future<bool> updateObject(ObjectModel updatedObject) async {
    // display debugPrint of the updated object
    debugPrint('Updated Object: ${updatedObject.toJson()}');

    // get editcontroller instance
    final controller = Get.put(EditObjectController());

    debugPrint(controller.hasImageChanged.value.toString());

    try {
      if (updatedObject.id == null  ) {
        debugPrint('Object ID not found.');
        return false;
      }

      // first check if image has changed or been updated

      String imageUrl = updatedObject.imgUrl ?? '';

      // if (controller.hasImageChanged.value == true) {
      //   try {
      //     final directoryName =
      //         "agencies/${updatedObject.agencyId}/buildings/${updatedObject.id}"; // Set the directory for storage

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
            "objects/${updatedObject.id}";

        try {
          late Map<String, dynamic> imageResponse;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          if (kIsWeb) {
            // WEB: upload directly from bytes
            // get datetime to add to filename
            //${DateTime.now().millisecondsSinceEpoch}

            final bytes = controller.memoryBytes.value!;
            final filename = "object_${updatedObject.id}.jpg";
            imageResponse = await _objectService.uploadAzureImage(
              bytes: bytes,
              filename: filename,
              id: updatedObject.id!,
              containerName: "docs",
              directoryName: directoryName,
            );
          } else {
            // MOBILE/DESKTOP: write to temp file then upload
            final temp = await writeBytesToTempFile(
              controller.memoryBytes.value!,
              'object_${updatedObject.id}.jpg',
            );
            imageResponse = await _objectService.uploadAzureImage(
              file: temp,
              filename: p.basename(temp.path),
              id: updatedObject.id!,
              containerName: 'docs',
              directoryName: directoryName,
            );
          }

          if (imageResponse['success'] != true) {
            debugPrint("Failed to upload image: ${imageResponse['message']}");
          } else {
            final data = jsonDecode(imageResponse['data']);
            final userImageUrl = data['url'] as String;
            debugPrint("Image URL: $userImageUrl");
            updatedObject.imgUrl = userImageUrl;
          }
        } catch (error) {
          debugPrint("Error uploading image: $error");
        }
      }

      // Update the building details

      debugPrint('User Image URL before updating: $imageUrl');

      final result = await _objectService.updateObject(
        updatedObject.id!,
        updatedObject.companyId!,
        updatedObject.name!,
        updatedObject.street!,
        updatedObject.zipCode!,
        updatedObject.description ?? '',
        updatedObject.city ?? '',
        updatedObject.currency ?? '',
        updatedObject.price ?? 0.0, 
        updatedObject.totalUnits ?? 0,
        updatedObject.totalFloors ?? 0,
        updatedObject.occupancy ?? '',
        updatedObject.zoning ?? '',
     
        updatedObject.country ?? '',
        updatedObject.state ?? '',
        updatedObject.address ?? '',
        updatedObject.owner ?? 0,
        updatedObject.status ?? 0,
        updatedObject.type_ ?? '',
        updatedObject.imgUrl ?? '',
        updatedObject.yieldGross ?? 0.0,
        updatedObject.yieldNet ?? 0.0,

      );

      if (result['success'] == false) {
        debugPrint('Error updating object: ${result['message']}');
        return false;
      }

      debugPrint('Update Object Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error updating object: $e');
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
  Future<bool> deleteObject(int id) async {
    try {
      final response = await _objectService.deleteObjectById(id);

      if (response['success'] != true) {
        throw Exception('Failed to delete object: ${response['message']}');
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting object: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> deleteObjectDirectory(String container, directory) async {
    try {
      final response = await _objectService.deleteObjectDirectory(
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
      final response = await _objectService.assignUnitsToZone(
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
      final response = await _objectService.assignUnitsBatch(assignments);

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
      final response = await _objectService.createAmenityZone(
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
      final List<Map<String, dynamic>> responseList = await _objectService
          .getObjectRequestLogs(requestId);

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
      final List<Map<String, dynamic>> responseList = await _objectService
          .getObjectRequestTypes(
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

  Future<List<BookingModel>> fetchObjectRecentBookingsByObjectId(
    int objectId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _objectService
          .getObjectRecentBookings(
            objectId,
          ); // replace with selected building id

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchObjectRecentBookingsByObjectId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchObjectRequestsByObjectId(
    int objectId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _objectService
          .getObjectAllRequests(objectId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchObjectRequestsByObjectId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchObjectsRequestsByCompanyId() async {
    final companyId = AuthenticationRepository.instance.currentUser!.companyId;

    try {
      final List<Map<String, dynamic>> responseList = await _objectService
          .getCompanyObjectsAllRequests(int.parse(companyId));

      if (responseList.isEmpty) return [];

      debugPrint('Response List: $responseList');

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchObjectsRequestsByCompanyId: $e');
      return [];
    }
  }

  Future<List<BookingModel>> fetchObjectsBookingsByCompanyId() async {
    try {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;

      final List<Map<String, dynamic>> responseList = await _objectService
          .getCompanyObjectsAllBookings(int.parse(companyId));

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchBuildingsBookingsByCompanyId: $e');
      return [];
    }
  }

  Future<bool> createObject(
    String objectName,
    String street,
    String zipCode,
    String description,
    String? city,
    String? currency,
    double? price,    
    int companyId,
    int totalUnits,
    int totalFloors,
    String occupancy,
    String zoning,
    String country,
    String type,
    String imageUrl,
    int? ownerId,
    int? statusId
  ) async {
    //final companyId = AuthenticationRepository.instance.currentUser!.companyId;
    try {
      debugPrint('[Create Object] Creating object: $objectName');


      final response = await _objectService.createObject(
        companyId,
        objectName,
        street,
        zipCode,
        description,
        city,
        currency,
        price,
        totalUnits,
        totalFloors,
        occupancy,
        zoning,
        country,
        type,
        imageUrl,
        ownerId,
        statusId
      );

      debugPrint('Create Object Response: $response');

      if (response['success'] == false) {
        return false;
      }

      final objectId = response['data'][0]['id'];

      final users =
          await UserController.instance.fetchUsersAndTranslateFields();
      // filter only admins
      final adminUsers = users.where((user) => user.roleExtId == 1).toList();

      // add to building permissions
      final user = UserController.instance.user.value;

      // remove the user from the list of admins
      final filteredAdmins =
          adminUsers.where((admin) => admin.id != user.id).toList();
      // assign the user to the object permission
      await assignUserToObjectPermission(objectId, int.parse(user.id!));

      // also assign to all admins
      for (final admin in filteredAdmins) {
        await assignUserToObjectPermission(objectId, int.parse(admin.id!));
      }

      return true;
    } catch (error) {
      debugPrint("Error in createObject: $error");
      return false;
    }
  }


  
  Future<List<UnitModel>> fetchCompanyObjectsUnits(String companyId) async {
    //   debugPrint('Building ID: $buildingId');

    try {
      if (companyId == null || companyId.isEmpty) {
        debugPrint('Company ID not found. fetchCompanyObjectsUnits');
        return [];
      }

      final response = await _objectService.getCompanyObjectsUnitsById(
        int.parse(companyId),
      );

      return response.map((unitData) => UnitModel.fromJson(unitData)).toList();
    } catch (e) {
      debugPrint('Error fetching company object units: $e');
      return [];
    }
  }


  Future<bool> updateUnitRoom(int unitId, int roomId) async {
    try {
      final result = await _objectService.updateObjectUnitRoom(
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

  Future<List<CategoryModel>> getAllCompanyAmenityCategories() async {
    try {
      final companyId = UserController.instance.user.value.companyId;

      if (companyId == null || companyId.isEmpty) {
        debugPrint('Company ID not found.');
        return [];
      }

      final response = await _objectService.getAllCompanyAmenityCategories(
        int.parse(companyId),
      );

      return response.map((data) => CategoryModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Error fetching company amenity categories: $e');
      return [];
    }
  }


  Future<List<BookingTimeslotModel>> getObjectAmenityUnitAvailability(
    int amenityUnitId,
    DateTime bookingDate,
    int excludeBookingId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _objectService
          .getObjectAmenityUnitTimeSlots(
            amenityUnitId,
            bookingDate,
            excludeBookingId,
          );

      if (responseList.isEmpty) return [];

      return responseList
          .map((data) => BookingTimeslotModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('Error in getObjectAmenityUnitAvailability: $e');
      return [];
    }
  }

  Future<bool> uploadNewDocument(
    int objectId,
    String directoryName,
    PickedFileDescriptor pickedFile

  ) async {
    try {
      // Now, we call the uploadAzureDocument function to upload the selected file
      final documentResponse = await _objectService.uploadAzureDocument(
        file: pickedFile,
        objectId: objectId, //
        containerName: "docs", // Set the container to store the file
        directoryName:
            directoryName, // Set the directory path for Azure Blob Storage
      );

      // final get file name
      final fileName = path.basename(pickedFile.path ?? ''  );
      // remove the extension
      final fileNameWithoutExtension = fileName.substring(
        0,
        fileName.lastIndexOf('.'),
      );
      // final fileExtension = fileName.substring(fileName.lastIndexOf('.'));
      final creatorId = AuthenticationRepository.instance.currentUser!.id;
      if (creatorId == null) {
        debugPrint("Creator ID is null");
        return false;
      }

      if (documentResponse['success'] == false) {
        debugPrint("Failed to upload document: ${documentResponse['message']}");
        return false;
      } else {
        final documentData = jsonDecode(documentResponse['data']);
        final docUrl =
            documentData['url']; // Retrieve the URL of the uploaded document
        final mediaResponse = await _objectService.createObjectMedia(
          objectId,
          docUrl,
          fileNameWithoutExtension,
          int.parse(creatorId),
          'agency_user',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error uploading document: $e');
      return false;
    }
  }


  Future<bool> assignUserToObjectPermission(
    int objectId,
    int userId,
  ) async {
    try {
      final response = await _objectService.assignUserToObjectPermission(
        objectId,
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
