import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:xm_frontend/data/models/annoucement_model.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';

import 'base_service.dart';
import '../api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UserService extends BaseService {
  // validateTenantInvitationToken

  Future<Map<String, dynamic>> validateTenantInvitationToken(
    String token,
  ) async {
    try {
      final response = await post(ApiEndpoints.validateTenantInvitationToken, {
        'token': token,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // Extract the first item from the data list
          final List<dynamic> dataList = response['data'];
          if (dataList.isNotEmpty && dataList.first is Map<String, dynamic>) {
            return dataList.first;
          }
        }
        throw Exception(response['message'] ?? 'Invalid token');
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      debugPrint('Failed to validate token: $error');
      throw Exception('Failed to validate token: $error');
    }
  }

  Future<Map<String, dynamic>> validateAgentInvitationToken(
    String token,
  ) async {
    try {
      final response = await post(ApiEndpoints.validateAgentInvitationToken, {
        'token': token,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // Extract the first item from the data list
          final List<dynamic> dataList = response['data'];
          if (dataList.isNotEmpty && dataList.first is Map<String, dynamic>) {
            return dataList.first;
          }
        }
        throw Exception(response['message'] ?? 'Invalid token');
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      debugPrint('Failed to validate token: $error');
      throw Exception('Failed to validate token: $error');
    }
  }

  // registerTenant

  Future<Map<String, dynamic>> registerTenant(
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final response = await post(ApiEndpoints.registerTenant, {
        'tenant': registrationData,
      });

      // debugPrint('User Service: registerTenant: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true) {
          // Return data only if it's present
          if (response.containsKey('data') && response['data'] != null) {
            return response['data'];
          } else {
            return {}; // Return an empty object if no data is provided
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to register tenant');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to register tenant: $error');
    }
  }

  Future<Map<String, dynamic>> registerAgent(
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final response = await post(ApiEndpoints.registerAgent, {
        'agent': registrationData,
      });

      // debugPrint('User Service: registerTenant: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true) {
          // Return data only if it's present
          if (response.containsKey('data') && response['data'] != null) {
            return response['data'];
          } else {
            return {}; // Return an empty object if no data is provided
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to register agent');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to register agent: $error');
    }
  }

  // get tenant by email

  Future<Map<String, dynamic>> getTenantByEmail(String email) async {
    try {
      final response = await post(ApiEndpoints.getTenantByEmail, {
        'email': email,
      });

      debugPrint('User Service: getTenantByEmail: $response');

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
          throw Exception(response['message'] ?? 'Tenant not found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get tenant by email: $error');
    }
  }

  Future<Map<String, dynamic>> getAgentByEmail(String email) async {
    try {
      final response = await post(ApiEndpoints.getAgentByEmail, {
        'email': email,
      });

      debugPrint('User Service: getAgentByEmail: $response');

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
          //  throw Exception(response['message'] ?? 'Agent not found');

          debugPrint('Agent not found: ' + response['message']);

          return {};
        }
      }

      return {};
    } catch (error) {
      //throw Exception('Failed to get tenant by email: $error');
      debugPrint('Failed to get agent by email: $error');

      return {};
    }
  }

  Future<Map<String, dynamic>> getAgentById(int id) async {
    try {
      final response = await post(ApiEndpoints.getAgentById, {'id': id});

      debugPrint('User Service: getAgentById: $response');

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
          //  throw Exception(response['message'] ?? 'Agent not found');

          debugPrint('Agent not found: ' + response['message']);

          return {};
        }
      }

      return {};
    } catch (error) {
      //throw Exception('Failed to get tenant by email: $error');
      debugPrint('Failed to get agent by id: $error');

      return {};
    }
  }

  Future<Map<String, dynamic>> getTenantById(int id) async {
    try {
      final response = await post(ApiEndpoints.getTenantById, {'id': id});

      //  debugPrint('User Service: getTenantByEmail: $response');

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
          throw Exception(response['message'] ?? 'Tenant not found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get tenant by email: $error');
    }
  }

  // get tenant upcoming booking

  Future<Map<String, dynamic>> getTenantUpcomingBooking(int contractId) async {
    try {
      final response = await post(ApiEndpoints.getTenantUpcomingBooking, {
        'contract_id': contractId,
      });

      //  debugPrint('User Service: getTenantUpcomingBooking: $response');

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
          throw Exception(response['message'] ?? 'No upcoming booking found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      debugPrint('Failed to get upcoming booking: $error');

      return {};
      //throw Exception('Failed to get upcoming booking: $error');
    }
  }

  /// **Create a new tenant request**
  Future<Map<String, dynamic>> createTenantBuildingRequest(
    int requestTypeId,
    int tenantId,
    int unitId,
    String description,
    int buildingId,
    int agencyId,
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingRequest, {
        'request_id': requestTypeId,
        'tenant_id': tenantId,
        'unit_id': unitId,
        'description': description,
        'building_id': buildingId,
        'agency_id': agencyId,
        'contract_id': contractId,
      });

      //   debugPrint('Create request response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingRequest: $error");
      return {"success": false, "message": "Failed to create request"};
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingRequestLog(
    int requestId,
    int status,
    String description,
    int processedById,
    String processedByType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingRequestLog, {
        'request_id': requestId,
        'status': status,
        'description': description,
        'processed_by_id': processedById,
        'processed_by_type': processedByType,
      });

      //    debugPrint('Create request log response: $response');

      return response;
    } catch (error) {
      //    debugPrint("Error in createTenantBuildingRequestLog: $error");
      return {"success": false, "message": "Failed to create request log"};
    }
  }

  /// **Upload an image for a request**
  // Future<Map<String, dynamic>> uploadRequestImage({
  //   required File file,
  //   required int requestId,
  //   required String containerName,
  //   required String directoryName,
  // }) async {
  //   try {
  //     final String baseUrl = dotenv.get('BASE_URL');

  //     // **Detect MIME type dynamically**
  //     String? mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

  //     // **Extract file extension correctly**
  //     String fileExtension = path.extension(file.path).replaceAll('.', '');

  //     // **Generate a new file name**
  //     String newFileName =
  //         "request_${requestId}_${DateTime.now().millisecondsSinceEpoch}";

  //     // **Construct the upload URL with query parameters**
  //     var uri = Uri.parse(
  //       '$baseUrl${ApiEndpoints.uploadUserMedia}' //
  //       '?containerName=$containerName'
  //       '&contentType=$mimeType'
  //       '&directoryName=$directoryName'
  //       '&newFileName=$newFileName',
  //     );

  //     // **Create multipart request**
  //     var request = http.MultipartRequest('POST', uri);

  //     // **Attach file to the request**
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'file',
  //       file.path,
  //     ));

  //     // **Send request**
  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     //  debugPrint("Upload response: ${response.statusCode} - $responseData");

  //     if (response.statusCode == 200) {
  //       return {
  //         "success": true,
  //         "message": "Image uploaded successfully",
  //         "data": responseData
  //       };
  //     } else {
  //       return {"success": false, "message": "Image upload failed"};
  //     }
  //   } catch (error) {
  //     debugPrint("Error uploading request image: $error");
  //     return {"success": false, "message": "Failed to upload image"};
  //   }
  // }

  Future<Map<String, dynamic>> uploadRequestImage({
    required File file,
    required int requestId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      String fileExtension = path.extension(file.path).replaceAll('.', '');
      String newFileName =
          "request_${requestId}_${DateTime.now().millisecondsSinceEpoch}";

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=$mimeType'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName',
      );

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Image uploaded successfully",
          "data": responseData,
        };
      } else {
        return {"success": false, "message": "Image upload failed"};
      }
    } catch (error) {
      debugPrint("Error uploading request image: $error");
      return {"success": false, "message": "Failed to upload image"};
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage({
    required File file,
    required int tenantId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      String fileExtension = path.extension(file.path).replaceAll('.', '');
      String newFileName =
          "profile_pic_${tenantId}_${DateTime.now().millisecondsSinceEpoch}";

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=$mimeType'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName',
      );

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Image uploaded successfully",
          "data": responseData,
        };
      } else {
        return {"success": false, "message": "Image upload failed"};
      }
    } catch (error) {
      debugPrint("Error uploading request image: $error");
      return {"success": false, "message": "Failed to upload image"};
    }
  }

  Future<Map<String, dynamic>> uploadPostImage({
    required File file,
    required int postId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      String fileExtension = path.extension(file.path).replaceAll('.', '');
      String newFileName =
          "post_${postId}_${DateTime.now().millisecondsSinceEpoch}";

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=$mimeType'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName',
      );

      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Image uploaded successfully",
          "data": responseData,
        };
      } else {
        return {"success": false, "message": "Image upload failed"};
      }
    } catch (error) {
      debugPrint("Error uploading request image: $error");
      return {"success": false, "message": "Failed to upload image"};
    }
  }

  /// **Create a new request media record**
  ///
  Future<Map<String, dynamic>> createTenantBuildingRequestMedia(
    int requestId,
    String mediaUrl,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.createTenantBuildingRequestMedia,
        {'request_id': requestId, 'media_url': mediaUrl},
      );

      return response;
    } catch (error) {
      debugPrint("Error in createRequestMedia: $error");
      return {"success": false, "message": "Failed to create request media"};
    }
  }

  Future<Map<String, dynamic>> updateTenantBuildingRequestStatus(
    int requestId,
    int status,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.updateTenantBuildingRequeststatus,
        {'request_id': requestId, 'status': status},
      );

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantBuildingRequestStatus: $error");
      return {"success": false, "message": "Failed to update request status"};
    }
  }

  /// Fetch tenant requests from backend
  Future<List<Map<String, dynamic>>> getTenantBuildingRequests(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingRequests, {
        'contract_id': contractId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building requests: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building requests: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingPost(
    int buildingId,
    int tenantId,
    String title,
    int isReceivePrivateMessage,
    String description,
    String creatorType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingPost, {
        'building_id': buildingId,
        'creator_id': tenantId,
        'title': title,
        'is_receive_private_message': isReceivePrivateMessage,
        'description': description,
        'creator_type': creatorType,
      });

      //   debugPrint('Create post response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingPost: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingPostMedia(
    int postId,
    String mediaUrl,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingPostMedia, {
        'post_id': postId,
        'media_url': mediaUrl,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createPostMedia: $error");
      return {"success": false, "message": "Failed to create post media"};
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingPostComment(
    int postId,
    int tenantId,
    String creatorType,
    String description,
    int postOwnerId,
  ) async {
    try {
      final response =
          await post(ApiEndpoints.createTenantBuildingPostComment, {
            'post_id': postId,
            'creator_id': tenantId,
            'creator_type': creatorType,
            'description': description,
            'post_owner_id': postOwnerId,
          });

      //   debugPrint('Create post response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingPostComment: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingPostLike(
    int postId,
    int userId,
    String userType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingPostLike, {
        'post_id': postId,
        'user_id': userId,
        'user_type': userType,
      });

      //   debugPrint('Create post like response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingPostLike: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }

  Future<Map<String, dynamic>> deleteTenantBuildingPostLike(
    int postId,
    int userId,
    String userType,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteTenantBuildingPostLike, {
        'post_id': postId,
        'user_id': userId,
        'user_type': userType,
      });

      //   debugPrint('Delete post like response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in deleteTenantBuildingPostLike: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }

  Future<Map<String, dynamic>> updateTenantPersonalDetails(
    int tenantId,
    String displayName,
    String phoneNumber,
    String countryCode,
    String profilePic,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantPersonalDetails, {
        'tenant_id': tenantId,
        'display_name': displayName,
        'phone_number': phoneNumber,
        'country_code': countryCode,
        'profile_pic': profilePic,
      });

      debugPrint('Update personal details response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantPersonalDetails: $error");
      return {
        "success": false,
        "message": "Failed to update tenant personal details status",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserPersonalDetails(
    int userId,
    String firstName,
    String lastName,
    String displayName,
    String profilePic,
    int roleExtId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserPersonalDetails, {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'display_name': displayName,
        'profile_pic': profilePic,
        'role_ext_id': roleExtId,
      });

      debugPrint('Update personal details response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateUserPersonalDetails: $error");
      return {
        "success": false,
        "message": "Failed to update user personal details status",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingUpcomingBookings(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantUpcomingBookings, {
        'contract_id': contractId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // debugPrint('Upcoming bookings: ${response['data']}');
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building upcominh bookings: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building upcoming bookings: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAllBookings(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantAllBookings, {
        'contract_id': contractId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // debugPrint('Upcoming bookings: ${response['data']}');
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building all bookings: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building all bookings: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAllBookingsByTenantId(
    int tenantId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantAllBookingsByTenantId, {
        'tenant_id': tenantId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // debugPrint('Upcoming bookings: ${response['data']}');
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building all bookings: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint(
        'Failed to get tenant building all bookings by tenant id: $error',
      );
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAllRequests(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantAllRequests, {
        'contract_id': contractId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // debugPrint('Upcoming bookings: ${response['data']}');
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building all requets: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building all requests: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAllRequestsByTenantId(
    int tenantId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantAllRequestsByTenantId, {
        'tenant_id': tenantId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // debugPrint('Upcoming bookings: ${response['data']}');
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building all requets by tenant id: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint(
        'Failed to get tenant building all requests by tenant id: $error',
      );
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingPastBookings(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantPastBookings, {
        'contract_id': contractId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building past bookings: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building past bookings: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingBookingTypes(
    int tenantId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingBookingTypes, {
        'tenant_id': tenantId,
      });

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get tenant building booking types: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get tenant building booking types: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAvailableAmenityUnits(
    int tenantId,
    int amenityId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.getTenantAvailableBuildingAmenityUnits,
        {'tenant_id': tenantId, 'amenity_id': amenityId},
      );

      //  debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //   debugPrint(
          //       'Failed to get tenant building available amenities: ${response['message']}');
          return [];
        }
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      //   debugPrint('Failed to get tenant building available amenities: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingBooking(
    int tenantId,
    int amenityUnitId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingBooking, {
        'tenant_id': tenantId,
        'amenity_unit_id': amenityUnitId,
        'booking_date': bookingDate.toIso8601String(),
        'start_time': startTime,
        'end_time': endTime,
        'contract_id': contractId,
      });

      //   debugPrint('Create booking response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingBooking: $error");
      return {"success": false, "message": "Failed to create request"};
    }
  }

  Future<Map<String, dynamic>> updateTenantBuildingBooking(
    int bookingId,
    int statusId,
    DateTime bookingDate,
    String startTime,
    String endTime,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantBuildingBooking, {
        'booking_id': bookingId,
        'status_id': statusId,
        'booking_date': bookingDate.toIso8601String(),
        'start_time': startTime,
        'end_time': endTime,
      });

      //   debugPrint('Update booking response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantBuildingBooking: $error");
      return {"success": false, "message": "Failed to update booking"};
    }
  }

  Future<Map<String, dynamic>> updateTenantBuildingBookingStatus(
    int bookingId,
    int statusId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.updateTenantBuildingBookingStatus,
        {'booking_id': bookingId, 'status_id': statusId},
      );

      //   debugPrint('Update booking status response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantBuildingBookingStatus: $error");
      return {"success": false, "message": "Failed to update booking status"};
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingDocs(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingDocs, {
        'contract_id': contractId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building docs: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building docs: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingHelpGuides(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingHelpGuides, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw help guides: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building help guides: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building help guides: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> sendTenantPasswordResetEmail(
    String email,
    String greetings,
    String bodyText,
    String resetCodeText,
    String resetCode,
    String availableOnText,
    String helpText,
    String supportText,
    String subject,
  ) async {
    try {
      final response = await post(ApiEndpoints.sendTenantPasswordResetEmail, {
        'email': email,
        'greetings': greetings,
        'body_text': bodyText,
        'reset_code_text': resetCodeText,
        'reset_code': resetCode,
        'available_on_text': availableOnText,
        'help_text': helpText,
        'support_text': supportText,
        'subject': subject,
      });

      //  debugPrint('User Service: sendTenantPasswordResetEmail: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true) {
          debugPrint('User Service: sendTenantPasswordResetEmail: $response');

          // Fix: Handle `data` as a List instead of Map
          if (response.containsKey('data') &&
              response['data'] is List &&
              response['data'].isNotEmpty) {
            return response['data'][0]; // Extract first object from the List
          } else {
            return {}; // Return an empty object if data is missing
          }
        } else {
          throw Exception(response['message'] ?? 'Not sent');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to send email: $error');
    }
  }

  Future<Map<String, dynamic>> updateTenantResetPasswordCode(
    String email,
    String resetCode,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantResetPasswordCode, {
        'email': email,
        'reset_code': resetCode,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantResetPasswordCode: $error");
      return {
        "success": false,
        "message": "Failed to update tenant reset password code",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserResetPasswordCode(
    String email,
    String resetCode,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserResetPasswordCode, {
        'email': email,
        'reset_code': resetCode,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserResetPasswordCode: $error");
      return {
        "success": false,
        "message": "Failed to update user reset password code",
      };
    }
  }

  Future<Map<String, dynamic>> updateTenantDeviceToken(
    int tenantId,
    String deviceToken,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantDeviceToken, {
        'tenant_id': tenantId,
        'device_token': deviceToken,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantDeviceToken: $error");
      return {
        "success": false,
        "message": "Failed to update tenant device token",
      };
    }
  }

  Future<Map<String, dynamic>> getTenantByResetCode(
    String email,
    resetCode,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantByResetCode, {
        'email': email,
        'reset_code': resetCode,
      });

      //  debugPrint('User Service: getTenantByResetCode: $response');

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
          throw Exception(response['message'] ?? 'Tenant not found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get tenant by reset code: $error');
    }
  }

  Future<Map<String, dynamic>> updateTenantPassword(
    int tenantId,
    String password,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantPassword, {
        'tenant_id': tenantId,
        'password': password,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantPassword: $error");
      return {"success": false, "message": "Failed to update tenant password"};
    }
  }

  Future<List<Map<String, dynamic>>> getTenantNotifications(
    int tenantId,
    int readFilter,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantNotifications, {
        'tenant_id': tenantId,
        'read_filter': readFilter,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant notifications: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant notifications: $error');
      return [];
    }
  }

  Future<RequestModel?> fetchRequestById(int requestId) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingRequestById, {
        'id': requestId,
      });

      // Debugging log
      debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return RequestModel.fromJson(
            response['data'][0],
          ); // Extract the first item from the list
        } else {
          debugPrint('Failed to fetch request: ${response['message']}');
          return null;
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return null;
      }
    } catch (error) {
      debugPrint('Failed to fetch request: $error');
      return null;
    }
  }

  Future<BookingModel?> fetchBookingById(int bookingId) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingBookingById, {
        'id': bookingId,
      });

      // Debugging log
      debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return BookingModel.fromJson(
            response['data'][0],
          ); //  Extract the first item from the list
        } else {
          debugPrint('Failed to fetch booking: ${response['message']}');
          return null;
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return null;
      }
    } catch (error) {
      debugPrint('Failed to fetch booking: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateTenantNotificationStatus(
    int id,
    int status,
  ) async {
    // status 1 = read, 0 = unread
    try {
      final response = await post(ApiEndpoints.updateTenantNotificationStatus, {
        'id': id,
        'status': status,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantNotificationStatus: $error");
      return {
        "success": false,
        "message": "Failed to update tenant notification status",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getTenantBuildingAnnoucemnts(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getTenantBuildingAnnoucemnts, {
        'building_id': buildingId,
      });

      //  debugPrint('Raw annoucemnts: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get tenant building annoucemnts: ${response['message']}');
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant building annoucemnts: $error');
      return [];
    }
  }

  Future<AnnoucementModel?> fetchAnnouncementById(int announcementId) async {
    try {
      final response = await post(
        ApiEndpoints.getTenantBuildingAnnouncementById,
        {'id': announcementId},
      );

      // Debugging log
      debugPrint('Raw response: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true &&
            response['data'] is List &&
            response['data'].isNotEmpty) {
          return AnnoucementModel.fromJson(
            response['data'][0],
          ); // Extract the first item from the list
        } else {
          debugPrint('Failed to fetch announcement: ${response['message']}');
          return null;
        }
      } else {
        debugPrint('Unexpected response format: $response');
        return null;
      }
    } catch (error) {
      debugPrint('Failed to fetch announcement: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteTenantDeviceToken(
    String deviceToken,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteTenantDeviceToken, {
        'device_token': deviceToken,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteTenantDeviceToken: $error");
      return {
        "success": false,
        "message": "Failed to delete tenant device token",
      };
    }
  }

  Future<Map<String, dynamic>> updateTenantBookingReminders(
    int tenantId,
    bool value,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantBookingReminders, {
        'tenant_id': tenantId,
        'val': value,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantBookingReminders: $error");
      return {
        "success": false,
        "message": "Failed to update tenant booking reminders",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getTenantDeviceTokens(int tenantId) async {
    try {
      final response = await post(ApiEndpoints.getTenantDeviceTokens, {
        'tenant_id': tenantId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // 🔹 Extract all fields from response['data']
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          debugPrint(
            'Failed to get tenant device tokens: ${response['message']}',
          );
          return [];
        }
      } else if (response is List) {
        // 🔹 If the backend is returning a raw list instead of JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get tenant device tokens: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> sendChatPushNotification(
    String token,
    String title,
    String body,
    String chatId,
    String receiverImage,
    String receiverName,
    String receiverId,
    String senderId,
    String senderImage,
    String receiverLangCode,
  ) async {
    try {
      // now swap the sender and receiver

      debugPrint(
        "sendChatPushNotification: $token, $title, $body, $chatId, $receiverImage, $receiverName, $receiverId, $senderId, $senderImage, $receiverLangCode",
      );

      final response = await post(ApiEndpoints.sendPushNotification, {
        'token': token,
        'title': title,
        'body': body,
        'type': "chat",
        'receiverLangCode': receiverLangCode,
        'data': {
          'chatId': chatId,
          'receiverImage': senderImage,
          'receiverName': title, // title is the receiver name
          'receiverId': senderId,
          'senderId': receiverId,
        },
      });

      return response;
    } catch (error) {
      debugPrint("Error in sendChatPushNotification: $error");
      return {"success": false, "message": "Failed to send push notification"};
    }
  }

  Future<Map<String, dynamic>> updateTenantLanguageCode(
    int tenantId,
    String langCode,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantLanguageCode, {
        'tenant_id': tenantId,
        'lang_code': langCode,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantLanguageCode: $error");
      return {
        "success": false,
        "message": "Failed to update tenant language code",
      };
    }
  }

  Future<Map<String, dynamic>> createTenantBuildingPostReport(
    int postId,
    int buildingId,
    int reportedbyId,
    String reason,
    String additionalComments,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantBuildingPostReport, {
        'post_id': postId,
        'building_id': buildingId,
        'reported_by_id': reportedbyId,
        'reason': reason,
        'additional_comments': additionalComments,
      });

      //   debugPrint('Create post report response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingPostReport: $error");
      return {"success": false, "message": "Failed to create post report"};
    }
  }

  Future<Map<String, dynamic>> deleteTenantBuildingPost(int postId) async {
    try {
      final response = await post(ApiEndpoints.deleteTenantBuildingPost, {
        'post_id': postId,
      });

      //   debugPrint('Delete post  response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in deleteTenantBuildingPost: $error");
      return {"success": false, "message": "Failed to delete post"};
    }
  }

  Future<Map<String, dynamic>> deleteTenantBuildingPostComment(
    int commentId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.deleteTenantBuildingPostComment,
        {'comment_id': commentId},
      );

      //   debugPrint('Delete post comment  response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in deleteTenantBuildingPost: $error");
      return {"success": false, "message": "Failed to delete post comment"};
    }
  }

  Future<List<Map<String, dynamic>>> getTenantsByContractId(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllTenantsByContract, {
        'contract_id': contractId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // debugPrint('Upcoming bookings: ${response['data']}');
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get all tenants by contract: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> createQuickNewTenant(
    String firstName,
    String lastName,
    String email,
    int buildingId,
    int createdById,
  ) async {
    try {
      final response = await post(ApiEndpoints.createQuickNewTenant, {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'building_id': buildingId,
        'created_by_id': createdById,
      });

      return response;
    } catch (error) {
      debugPrint("Error in quickCreateNewTenant: $error");
      return {"success": false, "message": "Failed to create new tenant"};
    }
  }

  Future<Map<String, dynamic>> updateQuickTenant(
    String firstName,
    String lastName,

    int buildingId,
    int tenantId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateQuickTenant, {
        'first_name': firstName,
        'last_name': lastName,
        'building_id': buildingId,
        'tenant_id': tenantId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateQuickTenant: $error");
      return {"success": false, "message": "Failed to update quick tenant"};
    }
  }

  Future<Map<String, dynamic>> updateTenantContractPrimary(
    int contractId,
    int tenantId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantContractPrimary, {
        'contract_id': contractId,
        'tenant_id': tenantId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantContractPrimary: $error");
      return {
        "success": false,
        "message": "Failed to update tenant contract primary status",
      };
    }
  }

  Future<Map<String, dynamic>> updateTenantRequestStatus(
    int requestId,
    int statusId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantRequestStatus, {
        'request_id': requestId,
        'status_id': statusId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantRequestStatus: $error");
      return {
        "success": false,
        "message": "Failed to update tenant request status",
      };
    }
  }

  Future<Map<String, dynamic>> createTenantContractNotificationAndSendPush(
    int contractId,
    int typeId,
    String message,
    int itemId,
  ) async {
    try {
      final response =
          await post(ApiEndpoints.createTenantContractNotificationAndSendPush, {
            'contract_id': contractId,
            'type_id': typeId,
            'message': message,
            'item_id': itemId,
          });

      return response;
    } catch (error) {
      debugPrint(
        "Error in createTenantContractNotificationAndSendPush: $error",
      );
      return {
        "success": false,
        "message": "Failed to create tenant request notification",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getTenantsByBuildingId(
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllTenantsByBuilding, {
        'building_id': buildingId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get all tenants by building: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTenantsByAgencyId(int agencyId) async {
    try {
      final response = await post(ApiEndpoints.getAllTenantsByAgency, {
        'agency_id': agencyId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get all tenants by agency: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteTenantBuildingTenant(
    int tenantId,
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteTenantBuildingTenant, {
        'tenant_id': tenantId,
        'building_id': buildingId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteTenantBuildingTenant: $error");
      return {
        "success": false,
        "message": "Failed to delete tenant building tenant",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getUsersByAgencyId(int agencyId) async {
    try {
      final response = await post(ApiEndpoints.getAllUsersByAgency, {
        'agency_id': agencyId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get all users by agency: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserRolesByRoleId(int roleId) async {
    try {
      final response = await post(ApiEndpoints.getUserRolesByRoleId, {
        'role_id': roleId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get all user roles: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> createNewUser(
    String firstName,
    String lastName,
    String email,
    int roleId,
    int roleExtId,
    int agencyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createNewUser, {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role_id': roleId,
        'role_ext_id': roleExtId,
        'agency_id': agencyId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createNewUser: $error");
      return {"success": false, "message": "Failed to create new user"};
    }
  }

  Future<Map<String, dynamic>> assignUserToBuildingsBatch(
    int userId,
    List<int> buildingIds,
  ) async {
    try {
      final response = await post(
        ApiEndpoints
            .assignUserToBuildingsBatch, // e.g. "/api/users/assign-buildings-batch"
        {'user_id': userId, 'building_ids': buildingIds},
      );
      return response;
    } catch (error) {
      debugPrint("Error in assignUserToBuildingsBatch: $error");
      return {"success": false, "message": "Failed to assign buildings"};
    }
  }

  Future<List<Map<String, dynamic>>> getUserAssignedBuildings(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserAssignedBuildings, {
        'user_id': userId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          return [];
        }
      } else if (response is List) {
        // If the backend is returning a raw list instead of a JSON object
        return List<Map<String, dynamic>>.from(response);
      } else {
        //   debugPrint('Unexpected response format: $response');
        return [];
      }
    } catch (error) {
      debugPrint('Failed to get all user assigned buildings: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteAllUserAssignedBuildings(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteAllUserAssignedBuildings, {
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteAllUserAssignedBuildings: $error");
      return {
        "success": false,
        "message": "Failed to delete all user assigned buildings",
      };
    }
  }

  Future<Map<String, dynamic>> deleteUserById(int userId) async {
    try {
      final response = await post(ApiEndpoints.deleteUserById, {
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserById: $error");
      return {"success": false, "message": "Failed to delete user"};
    }
  }

  Future<Map<String, dynamic>> deleteUserDirectory(
    String container,
    String directory,
  ) async {
    try {
      final response = await delete(ApiEndpoints.deleteUserDirectory, {
        'containerName': container,
        'directoryName': directory,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserDirectory: $error");
      return {"success": false, "message": "Failed to delete user directory"};
    }
  }

  Future<Map<String, dynamic>> createUserInvitationCode(
    String email,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserInvitationCode, {
        'email': email,
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createUserInvitationCode: $error");
      return {
        "success": false,
        "message": "Failed to create new user invitation code",
      };
    }
  }

  Future<Map<String, dynamic>> createTenantInvitationCode(
    String email,
    int tenantId,
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createTenantInvitationCode, {
        'email': email,
        'tenant_id': tenantId,
        'contract_id': contractId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createTenantInvitationCode: $error");
      return {
        "success": false,
        "message": "Failed to create new tenant invitation code",
      };
    }
  }

  Future<Map<String, dynamic>> sendUserInvitationEmail(
    String greetings,
    String bodyText,
    String invitationCodeText,
    String invitationCode,
    String availableOnText,
    String helpText,
    String supportText,
    String subject,
    String email,
  ) async {
    try {
      final response = await post(ApiEndpoints.sendUserInvitationEmail, {
        'greetings': greetings,
        'body_text': bodyText,
        'body2_title_text': invitationCodeText,
        'body2_text': invitationCode,
        'availableOnText': availableOnText,
        'helpText': helpText,
        'supportText': supportText,
        'subject': subject,
        'email': email,
      });

      return response;
    } catch (error) {
      debugPrint("Error in sendUserInvitationEmail: $error");
      return {
        "success": false,
        "message": "Failed to create new user invitation email",
      };
    }
  }

  Future<Map<String, dynamic>> sendTenantInvitationEmail(
    String greetings,
    String bodyText,
    String invitationCodeText,
    String invitationCode,
    String availableOnText,
    String helpText,
    String supportText,
    String subject,
    String email,
  ) async {
    try {
      final response = await post(ApiEndpoints.sendTenantInvitationEmail, {
        'greetings': greetings,
        'body_text': bodyText,
        'body2_title_text': invitationCodeText,
        'body2_text': invitationCode,
        'availableOnText': availableOnText,
        'helpText': helpText,
        'supportText': supportText,
        'subject': subject,
        'email': email,
      });

      return response;
    } catch (error) {
      debugPrint("Error in sendUserInvitationEmail: $error");
      return {
        "success": false,
        "message": "Failed to create new user invitation email",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserInvitationStatus(
    int id,
    int statusId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserInvitationStatus, {
        'id': id,
        'status': statusId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserInvitationStatus: $error");
      return {
        "success": false,
        "message": "Failed to update user invitation status",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserStatus(int id, int statusId) async {
    try {
      final response = await post(ApiEndpoints.updateUserStatus, {
        'id': id,
        'status_id': statusId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserStatus: $error");
      return {"success": false, "message": "Failed to update user status"};
    }
  }

  Future<Map<String, dynamic>> updateTenantBuildingStatus(
    int id,
    int statusId,
    int buildingId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTenantBuildingStatus, {
        'id': id,
        'status_id': statusId,
        'building_id': buildingId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantStatus: $error");
      return {"success": false, "message": "Failed to update tenant status"};
    }
  }

  Future<Map<String, dynamic>> sendUserPasswordResetEmail(
    String email,
    String greetings,
    String bodyText,
    String resetCodeText,
    String resetCode,
    String availableOnText,
    String helpText,
    String supportText,
    String subject,
  ) async {
    try {
      final response = await post(ApiEndpoints.sendUserPasswordResetEmail, {
        'email': email,
        'greetings': greetings,
        'body_text': bodyText,
        'reset_code_text': resetCodeText,
        'reset_code': resetCode,
        'available_on_text': availableOnText,
        'help_text': helpText,
        'support_text': supportText,
        'subject': subject,
      });

      //  debugPrint('User Service: sendTenantPasswordResetEmail: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true) {
          debugPrint('User Service: sendTenantPasswordResetEmail: $response');

          // Fix: Handle `data` as a List instead of Map
          if (response.containsKey('data') &&
              response['data'] is List &&
              response['data'].isNotEmpty) {
            return response['data'][0]; // Extract first object from the List
          } else {
            return {}; // Return an empty object if data is missing
          }
        } else {
          throw Exception(response['message'] ?? 'Not sent');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to send email: $error');
    }
  }

  Future<Map<String, dynamic>> getUserByResetCode(
    String email,
    resetCode,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserByResetCode, {
        'email': email,
        'reset_code': resetCode,
      });

      //  debugPrint('User Service: getTenantByResetCode: $response');

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
          throw Exception(response['message'] ?? 'Tenant not found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get tenant by reset code: $error');
    }
  }

  Future<Map<String, dynamic>> updateUserPassword(
    int userId,
    String password,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserPassword, {
        'user_id': userId,
        'password': password,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserPassword: $error");
      return {"success": false, "message": "Failed to update user password"};
    }
  }
}
