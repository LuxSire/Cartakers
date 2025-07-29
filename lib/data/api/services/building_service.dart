import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart'; // Import MediaType
import 'package:xm_frontend/data/models/contract_model.dart';

import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'base_service.dart';
import '../api_endpoints.dart';

class BuildingService extends BaseService {
  // get building last announcement

  Future<Map<String, dynamic>> getBuildingLastAnnouncement(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingsLastAnnouncement, {
        'building_id': buildingId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true) {
          // Fix: Handle `data` as a List instead of Map
          if (response.containsKey('data') &&
              response['data'] is List &&
              response['data'].isNotEmpty) {
            return response['data'][0]; // Extract first object from the List
          } else {
            return {}; // Return an empty object if data is missing
          }
        } else {
          throw Exception(response['message'] ?? 'No last announcement found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get last announcement: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingRequestTypes(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingRequestTypes, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building request types: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingRequestLogs(
    int requestId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingRequestLogs, {
        'request_id': requestId,
      });

      debugPrint('Raw response getBuildingRequestLogs:  $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //     debugPrint(
          //      'Failed to get building request logs: ${response['message']}');
          return [];
        }
      } else {
        //    debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get building request logs: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingContactNumbers(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingContactNumbers, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building request types: $error');
      return [];
    }
  }

  Future<List<List<Map<String, dynamic>>>> getBuildingPosts(
    int buildingId,
    int userId,
    String userType,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingPosts, {
        'building_id': buildingId,
        'user_id': userId,
        'user_type': userType,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          List<dynamic> data = response['data'];

          if (data.length < 3) {
            debugPrint(
              'Error: Expected 3 result sets (posts, comments, media), but received ${data.length}',
            );
            return [[], [], []]; // Return empty lists if incomplete data
          }

          // Convert each result set to a List<Map<String, dynamic>>
          List<Map<String, dynamic>> postsData =
              List<Map<String, dynamic>>.from(data[0]);
          List<Map<String, dynamic>> commentsData =
              List<Map<String, dynamic>>.from(data[1]);
          List<Map<String, dynamic>> mediaData =
              List<Map<String, dynamic>>.from(data[2]);

          return [postsData, commentsData, mediaData];
        } else {
          debugPrint('Failed to get building posts: ${response['message']}');
          return [[], [], []]; // Return empty lists
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return [[], [], []]; // Return empty lists
      }
    } catch (error) {
      debugPrint('Failed to get building posts: $error');
      return [[], [], []]; // Return empty lists
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingBookingTypes(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingBookingTypes, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building booking types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building booking types: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingAmenityUnitTimeSlots(
    int amenityUnitId,
    DateTime date,
    int excludeBookingId,
  ) async {
    try {
      final response =
          await post(ApiEndpoints.getBuildingAmenityUnitTimeslots, {
            'amenity_unit_id': amenityUnitId,
            'date': date.toIso8601String(),
            'exclude_booking_id': excludeBookingId,
          });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building amenity time slots: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building amenity time slots: $error');
      return [];
    }
  }

  Future<BuildingModel?> fetchBuildingById(int buildingId) async {
    try {
      final response = await post(ApiEndpoints.getBuildingById, {
        'id': buildingId,
      });

      // Debugging log
      debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return BuildingModel.fromJson(
            response['data'][0],
          ); // Extract the first item from the list
        } else {
          debugPrint('Failed to fetch building: ${response['message']}');
          return null;
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return null;
      }
    } catch (error) {
      debugPrint('Failed to fetch building: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingsByAgencyId(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingsByAgencyId, {
        'agency_id': agencyId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building request types: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateBuildingDetails(
    int buildingId,
    String name,
    String street,
    String buildingNumber,
    String zipCode,
    String location,
    String imageURL,
  ) async {
    try {
      debugPrint(
        'Updating building details: $buildingId, $name, $street, $buildingNumber, $zipCode, $location, $imageURL',
      );
      final response = await post(ApiEndpoints.updateBuildingDetails, {
        'building_id': buildingId,
        'name': name,
        'street': street,
        'building_number': buildingNumber,
        'zip_code': zipCode,
        'location': location,
        'image_url': imageURL,
      });

      debugPrint('Update building details response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateBuildingDetails: $error");
      return {
        "success": false,
        "message": "Failed to update building details status",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingUnitsById(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingUnitsById, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAgencyBuildingsUnitsById(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAgencyBuildingsUnitsById, {
        'agency_id': agencyId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getZonesForBuilding(int buildingId) async {
    try {
      final response = await post(ApiEndpoints.getBuildingZonesById, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getZoneAssignmentsByBuildingId(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingZoneAssigmentById, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingUnitContractsByUnitId(
    int unitId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.getBuildingUnitContractsByUnitId,
        {'unit_id': unitId},
      );

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllNonContractTenantsByBuildingId(
    int buildingId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.getBuildingNonContractTenantsByBuildingId,
        {'building_id': buildingId},
      );

      debugPrint(
        'getAllNonContractTenantsByBuildingId Raw response: $response',
      );

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllBuildingContracts(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllBuildingContracts, {
        'building_id': buildingId,
      });

      debugPrint('getAllBuildingContracts Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  // Future<Map<String, dynamic>> uploadAzureImage({
  //   required File file,
  //   required int buildingId,
  //   required String containerName,
  //   required String directoryName,
  // }) async {
  //   try {
  //     final String baseUrl = dotenv.get('BASE_URL');
  //     String? mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
  //     String fileExtension = path.extension(file.path).replaceAll('.', '');
  //     String newFileName =
  //         //  "img_background_${buildingId}_${DateTime.now().millisecondsSinceEpoch}";
  //         "img_background_$buildingId";

  //     var uri = Uri.parse(
  //       '$baseUrl${ApiEndpoints.uploadUserMedia}'
  //       '?containerName=$containerName'
  //       '&contentType=$mimeType'
  //       '&directoryName=$directoryName'
  //       '&newFileName=$newFileName',
  //     );

  //     var request = http.MultipartRequest('POST', uri);
  //     request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     if (response.statusCode == 200) {
  //       return {
  //         "success": true,
  //         "message": "Image uploaded successfully",
  //         "data": responseData,
  //       };
  //     } else {
  //       return {"success": false, "message": "Image upload failed"};
  //     }
  //   } catch (error) {
  //     debugPrint("Error uploading request image: $error");
  //     return {"success": false, "message": "Failed to upload image"};
  //   }
  // }

  // Future<Map<String, dynamic>> uploadAzureImage({
  //   // On mobile/desktop, pass in `file: myFile`
  //   File? file,
  //   // On web, pass in `bytes: myBytes, filename: 'foo.jpg'`
  //   Uint8List? bytes,
  //   String? filename,
  //   required int buildingId,
  //   required String containerName,
  //   required String directoryName,
  // }) async {
  //   try {
  //     final String baseUrl = dotenv.get('BASE_URL');
  //     late String mimeType;
  //     late String newFileName;
  //     late http.MultipartFile multipartFile;

  //     if (kIsWeb) {
  //       // --- WEB PATH ---
  //       if (bytes == null || filename == null) {
  //         throw ArgumentError('On web you must supply bytes and filename');
  //       }
  //       mimeType = lookupMimeType(filename) ?? 'application/octet-stream';
  //       newFileName = filename;
  //       multipartFile = http.MultipartFile.fromBytes(
  //         'file',
  //         bytes,
  //         filename: newFileName,
  //         contentType: MediaType.parse(mimeType),
  //       );
  //     } else {
  //       // --- MOBILE/DESKTOP PATH ---
  //       if (file == null) {
  //         throw ArgumentError('On non-web you must supply a File');
  //       }
  //       final ext = p.extension(file.path);
  //       mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
  //       newFileName = 'img_background_$buildingId$ext';
  //       multipartFile = await http.MultipartFile.fromPath(
  //         'file',
  //         file.path,
  //         filename: newFileName,
  //         contentType: MediaType.parse(mimeType),
  //       );
  //     }

  //     final uri = Uri.parse(
  //       '$baseUrl${ApiEndpoints.uploadUserMedia}'
  //       '?containerName=$containerName'
  //       '&contentType=${Uri.encodeComponent(mimeType)}'
  //       '&directoryName=$directoryName'
  //       '&newFileName=$newFileName',
  //     );

  //     final request = http.MultipartRequest('POST', uri)
  //       ..files.add(multipartFile);

  //     final response = await request.send();
  //     final responseData = await response.stream.bytesToString();

  //     if (response.statusCode == 200) {
  //       debugPrint('Image uploaded successfully: $responseData');
  //       return {
  //         "success": true,
  //         "message": "Image uploaded successfully",
  //         "data": responseData,
  //       };
  //     } else {
  //       debugPrint(
  //         'Image upload failed with status code ${response.statusCode}: $responseData',
  //       );
  //       return {
  //         "success": false,
  //         "message": "Image upload failed",
  //         "data": responseData,
  //       };
  //     }
  //   } catch (error) {
  //     debugPrint("Error uploading image: $error");
  //     return {"success": false, "message": "Failed to upload image"};
  //   }
  // }

  Future<Map<String, dynamic>> uploadAzureImage({
    File? file,
    Uint8List? bytes,
    required String filename,
    required int id,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final baseUrl = dotenv.get('BASE_URL');

      // Build multipart
      final rawName = kIsWeb ? filename! : p.basename(file!.path);
      final mimeType = lookupMimeType(rawName) ?? 'application/octet-stream';
      final newFileName = p.basenameWithoutExtension(rawName); // <-- NO ".jpg"

      final multipartFile =
          kIsWeb
              // Web: fromBytes
              ? http.MultipartFile.fromBytes(
                'file',
                bytes!, // your Uint8List
                filename: newFileName, // e.g. 'building_17'
                contentType: MediaType.parse(mimeType),
              )
              // Mobile/Desktop: fromPath
              : await http.MultipartFile.fromPath(
                'file',
                file!.path, // actual File path
                filename: newFileName,
                contentType: MediaType.parse(mimeType),
              );

      // Build your URL
      final uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=${Uri.encodeComponent(mimeType)}'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName', // no extension here
      );

      final request = http.MultipartRequest('POST', uri)
        ..files.add(multipartFile);

      final streamed = await request.send();
      final respText = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200) {
        debugPrint('Azure Image uploaded successfully: $respText');
        return {
          'success': true,
          'message': 'Image uploaded successfully',
          'data': respText,
        };
      } else {
        return {
          'success': false,
          'message': 'Image upload failed (${streamed.statusCode})',
          'data': respText,
        };
      }
    } catch (e) {
      debugPrint('Error in uploadAzureImage: $e');
      return {'success': false, 'message': 'Failed to upload image'};
    }
  }

  Future<ContractModel?> fetchContractById(int contractId) async {
    try {
      final response = await post(ApiEndpoints.getContractById, {
        'contract_id': contractId,
      });

      // Debugging log
      //   debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return ContractModel.fromJson(
            response['data'][0],
          ); // Extract the first item from the list
        } else {
          debugPrint('Failed to fetch contract : ${response['message']}');
          return null;
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return null;
      }
    } catch (error) {
      debugPrint('Failed to fetch contract: $error');
      return null;
    }
  }

  Future<ContractModel?> fetchActiveContractByUnitId(int unitId) async {
    try {
      final response = await post(ApiEndpoints.getActiveContractByUnitId, {
        'unit_id': unitId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return ContractModel.fromJson(response['data'][0]);
        } else {
          debugPrint(
            'No active contract found (handled gracefully): ${response['message']}',
          );
          return null;
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('Handled 404: No active contract exists for unit $unitId');
        return null; // Treat 404 as no data
      } else {
        debugPrint('Dio error: ${e.message}');
        rethrow; // Let other errors bubble up
      }
    } catch (error) {
      debugPrint('Unknown error fetching active contract: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateContractDetails(
    int contractId,
    String contractCode,
    DateTime? startDate,
    DateTime? endDate,
    int statusId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateContractDetails, {
        'contract_id': contractId,
        'contract_code': contractCode,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'status_id': statusId,
      });

      // debugPrint('Update building contract response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateContractDetails: $error");
      return {
        "success": false,
        "message": "Failed to update building contract details",
      };
    }
  }

  Future<Map<String, dynamic>> createContract(
    String contractCode,
    DateTime? startDate,
    int statusId,
    int unitId,
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createContract, {
        'contract_code': contractCode,
        'start_date': startDate?.toIso8601String(),
        'status_id': statusId,
        'unit_id': unitId,
        'building_id': buildingId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createContract: $error");
      return {"success": false, "message": "Failed to create new contract"};
    }
  }

  Future<Map<String, dynamic>> updateUnitStatus(
    int unitId,
    int statusId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUnitstatus, {
        'unit_id': unitId,
        'status_id': statusId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUnitStatus: $error");
      return {"success": false, "message": "Failed to update unit status"};
    }
  }

  Future<Map<String, dynamic>> assignUnitsToZone({
    required int zoneId,
    required List<int> unitIds,
  }) async {
    try {
      final response = await post(ApiEndpoints.assignUnitsToZone, {
        'zone_id': zoneId,
        'unit_ids': unitIds, // Flutter will send this as a JSON array
      });

      return response;
    } catch (error) {
      debugPrint("Error in assignUnitsToZone: $error");
      return {
        "success": false,
        "message": "Failed to assign units to the zone",
      };
    }
  }

  Future<Map<String, dynamic>> assignUnitsBatch(
    List<Map<String, dynamic>> assignments,
  ) async {
    try {
      final response = await post(
        ApiEndpoints
            .assignUnitsBatch, // e.g. "/api/buildings/assign-units-batch"
        {'assignments': assignments},
      );

      return response;
    } catch (error) {
      debugPrint("Error in assignUnitsBatch: $error");
      return {"success": false, "message": "Failed to assign units in batch"};
    }
  }

  Future<Map<String, dynamic>> addTenantToContract(
    int contractId,
    int tenantId,
    int isPrimary,
  ) async {
    try {
      final response = await post(ApiEndpoints.addTenantToContract, {
        'contract_id': contractId,
        'tenant_id': tenantId,
        'is_primary': isPrimary,
      });

      debugPrint('Add tenant to contract response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in addTenantToContract: $error");
      return {"success": false, "message": "Failed to add tenant to  ontract"};
    }
  }

  Future<Map<String, dynamic>> deleteTenantsFromContract(int contractId) async {
    try {
      final response = await post(ApiEndpoints.deleteTenantsFromContract, {
        'contract_id': contractId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteTenantsFromContract: $error");
      return {
        "success": false,
        "message": "Failed to delete tenants from contract",
      };
    }
  }

  Future<Map<String, dynamic>> removeTenantFromContract(
    int contractId,
    int tenantId,
  ) async {
    try {
      final response = await post(ApiEndpoints.removeTenantFromContract, {
        'contract_id': contractId,
        'tenant_id': tenantId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in removeTenantFromContract: $error");
      return {
        "success": false,
        "message": "Failed to remove tenant from contract",
      };
    }
  }

  Future<Map<String, dynamic>> createAmenityZone(
    int buildingId,
    String amenityZoneName,
  ) async {
    try {
      final response = await post(ApiEndpoints.createAmenityZone, {
        'building_id': buildingId,
        'amenity_zone_name': amenityZoneName,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createAmenityZone: $error");
      return {"success": false, "message": "Failed to create amenity zone"};
    }
  }

  Future<List<Map<String, dynamic>>> getAllDocumentsByContractId(
    int contractId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.getBuildingNonContractTenantsByBuildingId,
        {'contract_id': contractId},
      );

      //   debugPrint(
      //     'getAllDocumentsByContractId Raw response: $response',
      //   );

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteDocumentFromAzure({
    required String fileName,
    required String containerName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');

      debugPrint('filename: $fileName'); // Debugging log

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.deleteUserMedia}', // Remove query parameters
      );

      // Create a map with the data to be sent in the body
      var requestBody = {'containerName': containerName, 'fileName': fileName};

      var response = await http.delete(
        uri,
        body: jsonEncode(requestBody), // Send the data as JSON in the body
        headers: {
          "Content-Type": "application/json",
        }, // Set the content type to JSON
      );

      debugPrint('Delete response: ${response.body}'); // Debugging log

      if (response.statusCode == 200) {
        return {"success": true, "message": "Document deleted successfully"};
      } else {
        return {"success": false, "message": "Document deletion failed"};
      }
    } catch (error) {
      debugPrint("Error deleting document: $error");
      return {"success": false, "message": "Failed to delete document"};
    }
  }

  Future<Map<String, dynamic>> uploadAzureDocument({
    required File file,
    required int contractId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.path); // Get the correct MIME type
      String fileExtension = path.extension(file.path).replaceAll('.', '');
      String newFileName =
          "${contractId}_${DateTime.now().millisecondsSinceEpoch}";

      // If MIME type couldn't be determined, set default (could be based on file extension)
      mimeType ??= 'application/octet-stream';

      // Build the URI for the Azure upload endpoint
      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=$mimeType'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName',
      );

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Return success response with file URL or relevant data from the response
        return {
          "success": true,
          "message": "Document uploaded successfully",
          "data": responseData,
        };
      } else {
        return {"success": false, "message": "Document upload failed"};
      }
    } catch (error) {
      debugPrint("Error uploading document: $error");
      return {"success": false, "message": "Failed to upload document"};
    }
  }

  Future<Map<String, dynamic>> createContractMedia(
    int contractId,
    String docUrl,
    String filaName,
    int creatorId,
    String creatorType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createContractMedia, {
        'contract_id': contractId,
        'doc_url': docUrl,
        'file_name': filaName,
        'creator_id': creatorId,
        'creator_type': creatorType,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createContractMedia: $error");
      return {
        "success": false,
        "message": "Failed to create new contract media",
      };
    }
  }

  Future<Map<String, dynamic>> deleteDocumentById(int documentId) async {
    try {
      final response = await post(ApiEndpoints.deleteDocumentById, {
        'document_id': documentId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteDocumentById: $error");
      return {"success": false, "message": "Failed to delete document by id"};
    }
  }

  Future<Map<String, dynamic>> updateFileName(
    int documentId,
    String newFileName,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateFileName, {
        'document_id': documentId,
        'file_name': newFileName,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateFileName: $error");
      return {"success": false, "message": "Failed to update file name"};
    }
  }

  Future<Map<String, dynamic>> deleteContractById(int contractId) async {
    try {
      final response = await post(ApiEndpoints.deleteContractById, {
        'contract_id': contractId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteContractById: $error");
      return {
        "success": false,
        "message": "Failed to delete contract by id",
        "sqlMessage": error.toString(),
      };
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingRecentBookings(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingRecentBookings, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingAllRequests(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getBuildingAllRequests, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAgencyBuildingsAllRequests(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAgencyBuildingsAllRequests, {
        'agency_id': agencyId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAgencyBuildingsAllBookings(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAgencyBuildingsAllBookings, {
        'agency_id': agencyId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createBuilding(
    int agencyId,
    String name,
    String street,
    String buildingNumber,
    String zipCode,
    String location,
    int totalUnits,
    int totalFloors,
  ) async {
    try {
      final response = await post(ApiEndpoints.createBuilding, {
        'agency_id': agencyId,
        'name': name,
        'street': street,
        'building_number': buildingNumber,
        'zip_code': zipCode,
        'location': location,
        'total_units': totalUnits,
        'total_floors': totalFloors,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createBuilding: $error");
      return {"success": false, "message": "Failed to create new building"};
    }
  }

  Future<List<Map<String, dynamic>>> getAllAgencyBuildingsContracts(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllAgencyBuildingsContracts, {
        'agency_id': agencyId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBuildingUnitRoomList() async {
    try {
      final response = await post(ApiEndpoints.getBuildingUnitRoomList, {});

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<Map<String, dynamic>> updateBuildingUnitRoom(
    int unitId,
    int roomId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateBuildingUnitRoom, {
        'unit_id': unitId,
        'room_id': roomId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateBuildingUnitRoom: $error");
      return {
        "success": false,
        "message": "Failed to update building unit room",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getAllAgencyAmenityCategories(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllAgencyAmenityCategories, {
        'agency_id': agencyId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building request types: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAvailableAmenityUnitsV2(
    int buildingId,
    int zoneId,
    int categoryId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.getTenantAvailableBuildingAmenityUnitsV2,
        {
          'building_id': buildingId,
          'zone_id': zoneId,
          'category_id': categoryId,
        },
      );

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMaintenanceServicers(
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getMaintenanceServicers, {
        'agency_id': agencyId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get building request types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get building request types: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> assignUserToBuildingPermission(
    int buildingId,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.assignUserToBuildingPermission, {
        'building_id': buildingId,
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in assignUserToBuildingPermission: $error");
      return {
        "success": false,
        "message": "Failed to assign user to building permission",
      };
    }
  }

  Future<Map<String, dynamic>> deleteBuildingById(int id) async {
    try {
      final response = await post(ApiEndpoints.deleteBuildingById, {'id': id});

      return response;
    } catch (error) {
      debugPrint("Error in deleteBuildingById: $error");
      return {"success": false, "message": "Failed to delete building by id"};
    }
  }

  Future<Map<String, dynamic>> deleteBuildingDirectory(
    String container,
    String directory,
  ) async {
    try {
      final response = await delete(ApiEndpoints.deleteUserDirectory, {
        // we ca use the same method as deleteUserDirectory
        'containerName': container,
        'directoryName': directory,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserDirectory: $error");
      return {"success": false, "message": "Failed to delete user directory"};
    }
  }
}
