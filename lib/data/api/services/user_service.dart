import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';
import 'package:xm_frontend/data/models/annoucement_model.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/data/repositories/media/media_repository.dart';
import 'base_service.dart';
import '../api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UserService extends BaseService {
  // validateTenantInvitationToken

  // The 'post' method is inherited from BaseService. 
  // Ensure BaseService defines 'post' as an async method.

  Future<Map<String, dynamic>> validateUserInvitationToken(
    String token,
  ) async {
    try {
      final response = await post(ApiEndpoints.validateUserInvitationToken, {
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

  Future<Map<String, dynamic>> validateCompanyInvitationToken(
    String token,
  ) async {
    try {
      final response = await post(ApiEndpoints.validateCompanyInvitationToken, {
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

  // registerUser

  Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final response = await post(ApiEndpoints.registerUser, {
        'user': registrationData,
      });

      debugPrint('User Service: registerUser: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true) {
          // Return data only if it's present
          if (response.containsKey('data') && response['data'] != null) {
            return response['data'];
          } else {
            return {}; // Return an empty object if no data is provided
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to register user');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to register user: $error');
    }
  }

  Future<Map<String, dynamic>> registerCompany(
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final response = await post(ApiEndpoints.registerCompany, {
        'company': registrationData,
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
          throw Exception(response['message'] ?? 'Failed to register company');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to register company: $error');
    }
  }

  // get user by email

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    try {
      final response = await post(ApiEndpoints.getUserByEmail, {
        'email': email,
      });

      debugPrint('User Service: getUserByEmail: $response');

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
          throw Exception(response['message'] ?? 'User not found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get user by email: $error');
    }
  }

  Future<Map<String, dynamic>> getCompanyByEmail(String email) async {
    try {
      final response = await post(ApiEndpoints.getCompanyByEmail, {
        'email': email,
      });

      debugPrint('User Service: getCompanyByEmail: $response');

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

          debugPrint('Company not found: ' + response['message']);

          return {};
        }
      }

      return {};
    } catch (error) {
      debugPrint('Failed to get company by email: $error');

      return {};
    }
  }

  Future<Map<String, dynamic>> getCompanyById(int id) async {
    try {
      final response = await post(ApiEndpoints.getCompanyById, {'id': id});

      debugPrint('User Service: getCompanyById : $response');

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

          debugPrint('Company not found: ' + response['message']);

          return {};
        }
      }

      return {};
    } catch (error) {
      //throw Exception('Failed to get tenant by email: $error');
      debugPrint('Failed to get company by id: $error');

      return {};
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await post(ApiEndpoints.getUserById, {'id': id});

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
          throw Exception(response['message'] ?? 'User not found');
        }
      }

      throw Exception('Unexpected response format');
    } catch (error) {
      throw Exception('Failed to get user by email: $error');
    }
  }


  Future<Map<String, dynamic>> getUserUpcomingBooking(int contractId) async {
    try {
      final response = await post(ApiEndpoints.getUserUpcomingBooking, {
        'contract_id': contractId,
      });

      //  debugPrint('User Service: getUserUpcomingBooking: $response');

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
  Future<Map<String, dynamic>> createUserObjectRequest(
    int requestTypeId,
    int userId,
    int unitId,
    String description,
    int objectId,
    int companyId,
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectRequest, {
        'request_id': requestTypeId,
        'user_id': userId,
        'unit_id': unitId,
        'description': description,
        'object_id': objectId,
        'company_id': companyId,
        'contract_id': contractId,
      });

      //   debugPrint('Create request response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createTenantBuildingRequest: $error");
      return {"success": false, "message": "Failed to create request"};
    }
  }

  Future<Map<String, dynamic>> createUserObjectRequestLog(
    int requestId,
    int status,
    String description,
    int processedById,
    String processedByType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectRequestLog, {
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
 
  Future<Map<String, dynamic>> deleteDocumentFromAzure({
    required String fileName,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');

      debugPrint('[deleteDocumentFromAzure] filename: $fileName, container: $containerName, directory: $directoryName');

      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.deleteUserMedia}',
      );

      // Backend expects all three: containerName, directoryName, fileName
      var requestBody = {
        'containerName': containerName,
        'directoryName': directoryName,
        'fileName': fileName,
      };
      debugPrint('[deleteDocumentFromAzure] Request body: $requestBody');
      var response = await http.delete(
        uri,
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": "application/json",
        },
      );

      debugPrint('[deleteDocumentFromAzure] Delete response: ${response.body}');

      if (response.statusCode == 200) {
        return {"success": true, "message": "Document deleted successfully"};
      } else if (response.statusCode == 404) {
        return {"success": false, "message": "File not found."};
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
    required int userId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.name ?? ''); // Get the correct MIME type
      debugPrint('[uploadAzureDocument] lookupMimeType for path: \'${file.name}\' => $mimeType');
      if (mimeType == null && file.name!.toLowerCase().endsWith('.pdf')) {
        debugPrint('[uploadAzureDocument] Fallback: Detected .pdf extension, setting mimeType to application/pdf');
        mimeType = 'application/pdf';
      }
      String fileExtension = path.extension(file.path ?? '').replaceAll('.', '');
      String newFileName = "${userId}_${DateTime.now().millisecondsSinceEpoch}";

      debugPrint('[uploadAzureDocument] Final mimeType: $mimeType');
      mimeType ??= 'application/pdf'; // Fallback to PDF if mimeType is still null
      var uri = Uri.parse(
        '$baseUrl${ApiEndpoints.uploadUserMedia}'
        '?containerName=$containerName'
        '&contentType=$mimeType'
        '&directoryName=$directoryName'
        '&newFileName=$newFileName',
      );
      debugPrint('[uploadAzureDocument] Upload URI: $uri');
      var request = http.MultipartRequest('POST', uri);
      request.fields['creatorId'] = userId.toString();
      
      
      if (kIsWeb) {
        debugPrint('[uploadAzureDocument] Platform: Web, reading file as bytes');
        try {
          final bytes = await file.bytes;
          if (bytes == null) {
            throw Exception('[uploadAzureDocument] File bytes are null');
          }
          debugPrint('[uploadAzureDocument] Read ${bytes.length} bytes from file');
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              bytes,
              filename: newFileName,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } catch (e) {
          debugPrint('[uploadAzureDocument] Error reading file as bytes: $e');
          rethrow;
        }
      } else {
        debugPrint('[uploadAzureDocument] Platform: Mobile/Desktop, using fromPath');
        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file',
              file.path ?? '',
              filename: newFileName,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } catch (e) {
          debugPrint('[uploadAzureDocument] Error adding file from path: $e');
          rethrow;
        }
      }
      
      debugPrint('[uploadAzureDocument] Sending request...');
      var response = await request.send();
      debugPrint('[uploadAzureDocument] Response status: ${response.statusCode}');
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
      debugPrint("[uploadAzureDocument] Error uploading document: $error");
      return {"success": false, "message": "Failed to upload document"};
    }
  }


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
    required int userId,
    required String containerName,
    required String directoryName,
  }) async {
    try {
      final String baseUrl = dotenv.get('BASE_URL');
      String? mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      String fileExtension = path.extension(file.path).replaceAll('.', '');
      String newFileName =
          "profile_pic_${userId}_${DateTime.now().millisecondsSinceEpoch}";

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
  Future<Map<String, dynamic>> createUserObjectRequestMedia(
    int requestId,
    String mediaUrl,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.createUserObjectRequestMedia,
        {'request_id': requestId, 'media_url': mediaUrl},
      );

      return response;
    } catch (error) {
      debugPrint("Error in createRequestMedia: $error");
      return {"success": false, "message": "Failed to create request media"};
    }
  }

  Future<Map<String, dynamic>> updateUserObjectRequestStatus(
    int requestId,
    int status,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.updateUserObjectRequestStatus,
        {'request_id': requestId, 'status': status},
      );

      return response;
    } catch (error) {
      debugPrint("Error in updateUserObjectRequestStatus: $error");
      return {"success": false, "message": "Failed to update request status"};
    }
  }

  /// Fetch user requests from backend
  Future<List<Map<String, dynamic>>> getUserObjectRequests(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserObjectRequests, {
        'object_id': objectId,
      });

      //  debugPrint('Raw requests: $response');

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          //    debugPrint(
          //        'Failed to get user object requests: ${response['message']}');
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

  Future<Map<String, dynamic>> createUserObjectPost(
    int objectId,
    int userId,
    String title,
    int isReceivePrivateMessage,
    String description,
    String creatorType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectPost, {
        'object_id': objectId,
        'creator_id': userId,
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

  Future<Map<String, dynamic>> createUserObjectPostMedia(
    int postId,
    String mediaUrl,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectPostMedia, {
        'post_id': postId,
        'media_url': mediaUrl,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createPostMedia: $error");
      return {"success": false, "message": "Failed to create post media"};
    }
  }

  Future<Map<String, dynamic>> createUserObjectPostComment(
    int postId,
    int userId,
    String creatorType,
    String description,
    int postOwnerId,
  ) async {
    try {
      final response =
          await post(ApiEndpoints.createUserObjectPostComment, {
            'post_id': postId,
            'creator_id': userId  ,
            'creator_type': creatorType,
            'description': description,
            'post_owner_id': postOwnerId,
          });

      //   debugPrint('Create post response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createUserObjectPostComment: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }

  Future<Map<String, dynamic>> createUserObjectPostLike (
    int postId,
    int userId,
    String userType,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectPostLike, {
        'post_id': postId,
        'user_id': userId,
        'user_type': userType,
      });

      //   debugPrint('Create post like response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in createUserObjectPostLike: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }

  Future<Map<String, dynamic>> deleteUserObjectPostLike(
    int postId,
    int userId,
    String userType,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteUserObjectPostLike, {
        'post_id': postId,
        'user_id': userId,
        'user_type': userType,
      });

      //   debugPrint('Delete post like response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserObjectPostLike: $error");
      return {"success": false, "message": "Failed to create post"};
    }
  }


  Future<Map<String, dynamic>> updateUserPersonalDetails(
    int userId,
    String firstName,
    String lastName,
    String displayName,
    String phoneNumber,
    String countryCode,
    String profilePic
    
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserPersonalDetails, {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'display_name': displayName,
        'phone_number': phoneNumber,
        'country_code': countryCode,
        'profile_pic': profilePic
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

  Future<List<Map<String, dynamic>>> getUserObjectAllBookingsByUserId(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserAllBookingsByUserId, {
        'user_id': userId,
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

  Future<List<Map<String, dynamic>>> getUserObjectAllRequests(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserAllRequests, {
        'user_id': userId,
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
      debugPrint('Failed to get user object all requests: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserObjectAllRequestsByUserId(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserAllRequestsByUserId, {
        'user_id': userId,
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

  Future<List<Map<String, dynamic>>> getUserObjectPastBookings(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserPastBookings, {
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
      debugPrint('Failed to get user object past bookings: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserObjectBookingTypes(
    int tenantId,
  ) async {
    try {
      final response = await super.post(ApiEndpoints.getUserObjectBookingTypes, {
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

  Future<Map<String, dynamic>> createUserObjectBooking(
    int userId,
    int amenityUnitId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectBooking, {
        'user_id': userId,
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

  Future<Map<String, dynamic>> updateUserObjectBooking(
    int bookingId,
    int statusId,
    DateTime bookingDate,
    String startTime,
    String endTime,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserObjectBooking, {
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

  Future<Map<String, dynamic>> updateUserObjectBookingStatus(
    int bookingId,
    int statusId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.updateUserObjectBookingStatus,
        {'booking_id': bookingId, 'status_id': statusId},
      );

      //   debugPrint('Update booking status response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantBuildingBookingStatus: $error");
      return {"success": false, "message": "Failed to update booking status"};
    }
  }

  Future<List<Map<String, dynamic>>> getUserDocs(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserDocs, {
        'user_id': userId,
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

  Future<List<Map<String, dynamic>>> getUserObjectHelpGuides(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserObjectHelpGuides, {
        'user_id': userId,
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
      debugPrint('Failed to get user object help guides: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> sendUserObjectPasswordResetEmail(
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
          debugPrint('User Service: sendUserPasswordResetEmail: $response');

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
        "message": "Failed to update tenant reset password code",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserDeviceToken(
    int tenantId,
    String deviceToken,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserDeviceToken, {
        'tenant_id': tenantId,
        'device_token': deviceToken,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserDeviceToken: $error");
      return {
        "success": false,
        "message": "Failed to update user device token",
      };
    }
  }

  Future<Map<String, dynamic>> updateTokenByUser(
    int userId,
    String email,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateTokenByUser, {
        'user_id': userId,
        'email': email,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTokenByUser: $error");
      return {
        "success": false,
        "message": "Failed to update token by user",
      };
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

      //  debugPrint('User Service: getUserByResetCode: $response');

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
          throw Exception(response['message'] ?? 'User not found');
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
        'tenant_id': userId,
        'password': password,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateTenantPassword: $error");
      return {"success": false, "message": "Failed to update tenant password"};
    }
  }

  Future<List<Map<String, dynamic>>> getUserNotifications(
    int userId,
    int readFilter,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserNotifications, {
        'user_id': userId,
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
      debugPrint('Failed to get user notifications: $error');
      return [];
    }
  }

  Future<RequestModel?> fetchRequestById(int requestId) async {
    try {
      final response = await post(ApiEndpoints.getUserObjectRequestById, {
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
      final response = await post(ApiEndpoints.getUserObjectBookingById, {
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

  Future<Map<String, dynamic>> updateUserNotificationStatus(
    int id,
    int status,
  ) async {
    // status 1 = read, 0 = unread
    try {
      final response = await post(ApiEndpoints.updateUserNotificationStatus, {
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

  Future<List<Map<String, dynamic>>> getUserObjectAnnouncements(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserObjectAnnouncements, {
        'object_id': objectId,
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
      debugPrint('Failed to get user object announcements: $error');
      return [];
    }
  }

  Future<AnnoucementModel?> fetchAnnouncementById(int announcementId) async {
    try {
      final response = await post(
        ApiEndpoints.getUserObjectAnnouncementById,
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

  Future<Map<String, dynamic>> deleteUserDeviceToken(
    String deviceToken,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteUserDeviceToken, {
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

  Future<Map<String, dynamic>> updateUserBookingReminders(
    int userId,
    bool value,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserBookingReminders, {
        'user_id': userId,
        'val': value,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserBookingReminders: $error");
      return {
        "success": false,
        "message": "Failed to update tenant booking reminders",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getUserDeviceTokens(int userId) async {
    try {
      final response = await post(ApiEndpoints.getUserDeviceTokens, {
        'user_id': userId,
      });

      if (response is Map<String, dynamic> && response.containsKey('success')) {
        if (response['success'] == true && response['data'] is List) {
          // 🔹 Extract all fields from response['data']
          return List<Map<String, dynamic>>.from(response['data']);
        } else {
          debugPrint(
            'Failed to get user device tokens: ${response['message']}',
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

  Future<Map<String, dynamic>> updateUserLanguageCode(
    int tenantId,
    String langCode,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserLanguageCode, {
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

  Future<Map<String, dynamic>> createUserObjectPostReport(
    int postId,
    int objectId,
    int reportedbyId,
    String reason,
    String additionalComments,
  ) async {
    try {
      final response = await post(ApiEndpoints.createUserObjectPostReport, {
        'post_id': postId,
        'object_id': objectId,
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

  Future<Map<String, dynamic>> deleteUserObjectPost(int postId) async {
    try {
      final response = await post(ApiEndpoints.deleteUserObjectPost, {
        'post_id': postId,
      });

      //   debugPrint('Delete post  response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserObjectPost: $error");
      return {"success": false, "message": "Failed to delete post"};
    }
  }

  Future<Map<String, dynamic>> deleteUserObjectPostComment(
    int commentId,
  ) async {
    try {
      final response = await post(
        ApiEndpoints.deleteUserObjectPostComment,
        {'comment_id': commentId},
      );

      //   debugPrint('Delete post comment  response: $response');

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserObjectPostComment: $error");
      return {"success": false, "message": "Failed to delete post comment"};
    }
  }

  Future<List<Map<String, dynamic>>> getUsersByContractId(
    int contractId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllUsersByContract, {
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
      debugPrint('Failed to get all users by contract: $error');
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getAllUsers(
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllUsers,{} );
        


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
      debugPrint('Failed to get all users: $error');
      return [];
    }
  }
    Future<List<Map<String, dynamic>>> getAllUserRoles(
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllUserRoles,{} );



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
      debugPrint('Failed to get all user roles: $error');
      return [];
    }
  }
  Future<Map<String, dynamic>> createQuickNewUser(
    String firstName,
    String lastName,
    String email,
    String phone_number,
    int roleId,
    int companyId,
    {String token = ''}
  ) async {
    try {
      final response = await post(ApiEndpoints.createQuickNewUser, {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phone_number,
        'role_id': roleId ?? 2,
        'company_id': companyId ?? 1,
        'token': token,
      });

      return response;
    } catch (error) {
      debugPrint("Error in quickCreateNewUser: $error");
      return {"success": false, "message": "Failed to create new user"};
    }
  }
  Future<Map<String, dynamic>> createQuickNewCompany(
    String name,
    String email,
    String phone_number,
    int roleId
   
   
  ) async {
    try {
      final response = await post(ApiEndpoints.createQuickNewCompany, {
        'name': name,
        'email': email,
        'phone_number': phone_number,
        'role_id': roleId ?? 2,
       
      });

      return response;
    } catch (error) {
      debugPrint("Error in quickCreateNewCompany: $error");
      return {"success": false, "message": "Failed to create new company"};
    }
  }
 


  Future<Map<String, dynamic>> updateQuickUser(
    String firstName,
    String lastName,

    int objectId,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateQuickUser, {
        'first_name': firstName,
        'last_name': lastName,
        'object_id': objectId,
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateQuickUser: $error");
      return {"success": false, "message": "Failed to update quick user"};
    }
  }

  Future<Map<String, dynamic>> updateUserContractPrimary(
    int contractId,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserContractPrimary, {
        'contract_id': contractId,
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserContractPrimary: $error");
      return {
        "success": false,
        "message": "Failed to update tenant contract primary status",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserRequestStatus(
    int requestId,
    int statusId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserRequestStatus, {
        'request_id': requestId,
        'status_id': statusId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserRequestStatus: $error");
      return {
        "success": false,
        "message": "Failed to update user request status",
      };
    }
  }

  Future<Map<String, dynamic>> createUserContractNotificationAndSendPush(
    int contractId,
    int typeId,
    String message,
    int itemId,
  ) async {
    try {
      final response =
          await post(ApiEndpoints.createUserContractNotificationAndSendPush, {
            'contract_id': contractId,
            'type_id': typeId,
            'message': message,
            'item_id': itemId,
          });

      return response;
    } catch (error) {
      debugPrint(
        "Error in createUserContractNotificationAndSendPush: $error",
      );
      return {
        "success": false,
        "message": "Failed to create user request notification",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getUsersByObjectId(
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getAllUsersByObject, {
        'object_id': objectId,
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
      debugPrint('Failed to get all users by object: $error');
      return [];
    }
  }


  Future<Map<String, dynamic>> deleteUserObjectUser(
    int userId,
    [int? objectId]
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteUserObjectUser, {
        'user_id': userId,
        'object_id': objectId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteUserObjectUser: $error");
      return {
        "success": false,
        "message": "Failed to delete user from object",
      };
    }
  }

  Future<List<Map<String, dynamic>>> getUsersByCompanyId(int companyId) async {
    try {
      final response = await post(ApiEndpoints.getUsersByCompany, {
        'company_id': companyId,
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
      debugPrint('Failed to get all users by company: $error');
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
    int companyId,
  ) async {
    try {
      final response = await post(ApiEndpoints.createNewUser, {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role_id': roleId,
        'role_ext_id': roleExtId,
        'company_id': companyId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in createNewUser: $error");
      return {"success": false, "message": "Failed to create new user"};
    }
  }

  Future<Map<String, dynamic>> assignUserToObjectsBatch(
    int userId,
    List<int> objectIds,
  ) async {
    try {
      final response = await post(
        ApiEndpoints
            .assignUserToObjectsBatch, // e.g. "/api/users/assign-objects-batch"
        {'user_id': userId, 'object_ids': objectIds},
      );
      return response;
    } catch (error) {
      debugPrint("Error in assignUserToObjectsBatch: $error");
      return {"success": false, "message": "Failed to assign objects"};
    }
  }

  Future<List<Map<String, dynamic>>> getUserAssignedObjects(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.getUserAssignedObjects, {
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
      debugPrint('Failed to get all user assigned objects: $error');
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteAllUserAssignedObjects(
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.deleteAllUserAssignedObjects, {
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
      debugPrint("Deleting user with ID: $userId");
      final response = await post(ApiEndpoints.deleteUserById, {
        'user_id': userId.toString(),
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
      debugPrint("Creating user invitation code for email: $email, userId: $userId");
      final response = await post(ApiEndpoints.createUserInvitationCode, {
        'email': email,
        'user_id': userId.toString(),
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
      return {"success": false, 
      "message": "Failed to update user status"
      };
    }
  }


  Future<Map<String, dynamic>> updateUserObjectStatus(
    int id,
    int statusId,
    int objectId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateUserObjectStatus, {
        'id': id,
        'status_id': statusId,
        'object_id': objectId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateUserObjectStatus: $error");
      return {"success": false, "message": "Failed to update user object status"
      };
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
}