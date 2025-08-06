import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart'; // Import MediaType
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:get/get.dart'; // Import for RxList
import 'package:xm_frontend/data/repositories/media/media_repository.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'base_service.dart';
import '../api_endpoints.dart';

class ObjectService extends BaseService {
  // get object last announcement


RxList<String> objectImages = <String>[].obs;

Future<List<Map<String, dynamic>>> fetchObjectImages(int objectId) async {
  final response = await post(ApiEndpoints.getObjectDocs, {
    'object_id': objectId,
  });
  if (response is Map<String, dynamic> && response['success'] == true) {
    if (response['data'] is List) {
      final allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];
      return (response['data'] as List<dynamic>)
        .where((doc) =>
          doc is Map<String, dynamic> &&
          allowedTypes.contains((doc['contentType'] ?? '').toLowerCase())
        )
        .map((doc) => doc as Map<String, dynamic>)
        .toList();
    }
  }
  return [];
}

  Future<List<Map<String, dynamic>>> fetchObjectDocs(int objectId) async {
  final response = await post(ApiEndpoints.getObjectDocs, {
    'object_id': objectId,
  });
  if (response is Map<String, dynamic> && response['success'] == true) {
    if (response['data'] is List) {
      return (response['data'] as List<dynamic>)
          .map((doc) => doc as Map<String, dynamic>)
          .toList();
    } else {
      debugPrint('No documents found for object $objectId');
    }
  }
  return [];
    }
  
 



  Future<Map<String, dynamic>> getObjectLastAnnouncement(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectsLastAnnouncement, {
        'object_id': objectId,
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

  Future<List<Map<String, dynamic>>> getObjectRequestTypes(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectRequestTypes, {
        'object_id': objectId,
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

  Future<List<Map<String, dynamic>>> getObjectRequestLogs(
    int requestId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectRequestLogs, {
        'request_id': requestId,
      });

      debugPrint('Raw response getObjectRequestLogs:  $response');

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
      debugPrint('Failed to get object request logs: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getObjectContactNumbers(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectContactNumbers, {
        'object_id': objectId,
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

  Future<List<List<Map<String, dynamic>>>> getObjectPosts(
    int objectId,
    int userId,
    String userType,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectPosts, {
        'object_id': objectId,
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

  Future<List<Map<String, dynamic>>> getObjectBookingTypes(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectBookingTypes, {
        'object_id': objectId,
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

  Future<List<Map<String, dynamic>>> getObjectAmenityUnitTimeSlots(
    int amenityUnitId,
    DateTime date,
    int excludeBookingId,
  ) async {
    try {
      final response =
          await post(ApiEndpoints.getObjectAmenityUnitTimeslots, {
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

  Future<ObjectModel?> fetchObjectById(int objectId) async {
    try {
      final response = await post(ApiEndpoints.getObjectById, {
        'id': objectId,
      });

      // Debugging log
      debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return ObjectModel.fromJson(
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

  Future<List<Map<String, dynamic>>> getObjectsByCompanyId(
    int companyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectsByCompanyId, {
        'company_id': companyId,
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
  Future<List<Map<String, dynamic>>> getAllObjects(

  ) async {
    try {
      final response = await post(ApiEndpoints.getAllObjects, {});

        debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else {        return [];
      }
    } catch (error) {
      
      return [];
    }
  }

  Future<Map<String, dynamic>> updateObjectDetails(
    int objectId  ,
    String name,
    String street,
    String zipCode,
    String location,
    String imageURL,
    String description,
  ) async {
    try {
      debugPrint(
        'Updating object details: $objectId, $name, $street, $zipCode, $location, $imageURL, $description',
      );
      final response = await post(ApiEndpoints.updateObjectDetails, {
        'object_id': objectId,
        'name': name,
        'street': street,
        'zip_code': zipCode,
        'location': location,
        'image_url': imageURL,
        'description': description,
      });

      debugPrint('Update object details response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateObjectDetails: $error");
      return {
        "success": false,
        "message": "Failed to update object details status",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getObjectUnitsById(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectUnitsById, {
        'object_id': objectId,
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

  Future<List<Map<String, dynamic>>> getCompanyObjectsUnitsById(
    int companyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getCompanyObjectsUnitsById, {
        'company_id': companyId,
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

  Future<List<Map<String, dynamic>>> getZonesForObject(int objectId) async {
    try {
      final response = await post(ApiEndpoints.getObjectZonesById, {
        'object_id': objectId,
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


  Future<List<Map<String, dynamic>>> getAllNonContractUsersByObjectId(
    int objectId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.getObjectNonContractUsersByObjectId,
        {'object_id': objectId},
      );

      debugPrint(
        'getAllNonContractUsersByObjectId Raw response: $response',
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

  Future<List<Map<String, dynamic>>> getAllObjectContracts(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllObjectContracts, {
        'object_id': objectId,
      });

      debugPrint('getAllObjectContracts Raw response: $response');

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

  Future<Map<String, dynamic>> addUserToContract(
    int contractId,
    int userId,
    int isPrimary,
  ) async {
    try {
      final response = await post(ApiEndpoints.addUserToContract, {
        'contract_id': contractId,
        'user_id': userId,
        'is_primary': isPrimary,
      });

      debugPrint('Add user to contract response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in addUserToContract: $error");
      return {"success": false, "message": "Failed to add user to contract"};
    }
  }

  Future<Map<String, dynamic>> deleteUsersFromContract(int contractId) async {
    try {
      final response = await post(ApiEndpoints.deleteUsersFromContract, {
        'contract_id': contractId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteUsersFromContract: $error");
      return {
        "success": false,
        "message": "Failed to delete users from contract",
      };
    }
  }

  Future<Map<String, dynamic>> removeUserFromContract(
    int contractId,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.removeUserFromContract, {
        'contract_id': contractId,
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in removeUserFromContract: $error");
      return {
        "success": false,
        "message": "Failed to remove user from contract",
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
        ApiEndpoints.getObjectNonContractUsersByObjectId,
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
    required String directoryName,  
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');

      debugPrint('filename: $fileName'); // Debugging log

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.deleteUserMedia}', // Remove query parameters
      );

      // Create a map with the data to be sent in the body
      var requestBody = {'containerName': containerName, 'directoryName': directoryName, 'fileName': fileName};

      debugPrint('Delete URI: $uri'); // Debugging log
      debugPrint('Request body: $requestBody'); // Debugging log

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
    required PickedFileDescriptor file,
    required int objectId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.name ?? ''); // Get the correct MIME type
      String fileExtension = path.extension(file.name ?? '').replaceAll('.', '');
      String newFileName = "${objectId}_${DateTime.now().millisecondsSinceEpoch}";

      mimeType ??= 'application/pdf';

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=$mimeType'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName',
      );
      debugPrint('Upload URI: $uri'); // Debugging log
      var request = http.MultipartRequest('POST', uri);

      if (kIsWeb) {
        // Web: Read file as bytes and use MultipartFile.fromBytes
        final bytes = await file.bytes;
        if (bytes == null) {
            throw Exception('[uploadAzureDocument] File bytes are null');
          }
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
             bytes,
            filename: newFileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        // Mobile/Desktop: Use MultipartFile.fromPath
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path ?? '',
            filename: newFileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      debugPrint('[uploadAzureDocument] Response data: $responseData');
      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> createObjectMedia(
    int objectId,
    String docUrl,
    String filaName,
    int creatorId,
    String creatorType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createObjectMedia, {
        'object_id': objectId,
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

  Future<Map<String, dynamic>> deleteDocumentById(String documentId) async {
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
    String documentId,
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

  Future<List<Map<String, dynamic>>> getObjectRecentBookings(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectRecentBookings, {
        'object_id': objectId ,
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

  Future<List<Map<String, dynamic>>> getObjectAllRequests(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getObjectAllRequests, {
        'object_id': objectId,
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

  Future<List<Map<String, dynamic>>> getCompanyObjectsAllRequests(
    int companyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getCompanyObjectsAllRequests, {
        'company_id': companyId,
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

  Future<List<Map<String, dynamic>>> getCompanyObjectsAllBookings(
    int companyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getCompanyObjectsAllBookings, {
        'company_id': companyId,
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

  Future<Map<String, dynamic>> createObject(
    int companyId,
    String name,
    String street,
    String objectNumber,
    String zipCode,
    String location,
    int totalUnits,
    int totalFloors,
  ) async {
    try {
      final response = await post(ApiEndpoints.createObject, {
        'company_id': companyId,
        'name': name,
        'street': street,
        'object_number': objectNumber,
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

  Future<List<Map<String, dynamic>>> getAllCompanyObjectsContracts(
    int companyId,
  ) async {
    try {
      //   debugPrint('Unexpected response format: $response');
      return [];
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getObjectUnitRoomList() async {
    try {
      final response = await post(ApiEndpoints.getObjectUnitRoomList, {});

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

  Future<Map<String, dynamic>> updateObjectUnitRoom(
    int unitId,
    int roomId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateObjectUnitRoom, {
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

  Future<List<Map<String, dynamic>>> getAllCompanyAmenityCategories(
    int companyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllCompanyAmenityCategories, {
        'company_id': companyId,
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

  Future<Map<String, dynamic>> assignUserToObjectPermission(
    int objectId,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.assignUserToObjectPermission, {
        'object_id': objectId ,
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

  Future<Map<String, dynamic>> deleteObjectById(int id) async {
    try {
      final response = await post(ApiEndpoints.deleteObjectById, {'id': id});

      return response;
    } catch (error) {
      debugPrint("Error in deleteObjectById: $error");
      return {"success": false, "message": "Failed to delete object by id"};
    }
  }

  Future<Map<String, dynamic>> deleteObjectDirectory(
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
