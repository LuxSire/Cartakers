import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:xm_frontend/data/api/services/object_service.dart';
import 'package:xm_frontend/data/api/services/user_service.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
//import 'package:xm_frontend/data/models/request_log_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/user_role_model.dart';
//import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import '../../../features/personalization/models/user_model.dart';
//import '../../../utils/exceptions/firebase_auth_exceptions.dart';
//import '../../../utils/exceptions/format_exceptions.dart';
//import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';
import 'package:path/path.dart' as p;

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final UserService _userService = Get.put(UserService()); // Inject Service

  /// Function to fetch user details based on user ID.
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _userService.getAllUsers();
      return response.map((userData) => UserModel.fromJson(userData)).toList();
    } catch (e) {
      debugPrint('Error fetching users from getAllUsers: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllObjectUsers(String objectId) async {
    try {
      if (objectId == null || objectId.isEmpty) {
        debugPrint('Object ID not found.');
        return [];
      }

      final response = await _userService.getUsersByObjectId(
        int.parse(objectId),
      );


      return response
          .map((userData) => UserModel.fromJson(userData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching users from getAllObjectUsers: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllCompanyObjectUsers() async {
    try {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;

      if (companyId == null || companyId.isEmpty) {
        debugPrint('Company ID not found.');
        return [];
      }

      final response = await _userService.getUsersByCompanyId(
        int.parse(companyId),
      );
       debugPrint('Raw response: $response');
      return response
          .map((userData) => UserModel.fromJson(userData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching users from getAllCompanyObjectUsers: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllCompanyUsers() async {
    try {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;

      if (companyId == null || companyId.isEmpty) {
        debugPrint('Company ID not found.');
        return [];
      }

      final response = await _userService.getUsersByCompanyId(
        int.parse(companyId),
      );
      debugPrint('Raw response: $response');
      return response.map((userData) => UserModel.fromJson(userData)).toList();
    } catch (e) {
      debugPrint('Error fetching users from getAllCompanyUsers: $e');
      return [];
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    var userId = '0';

    try {
      userId = AuthenticationRepository.instance.currentUser!.id.toString();
    } catch (e) {
      debugPrint('Error: $e');
      return UserModel.empty();
    }

    final response = await _userService.getUserById(
      int.parse(userId.toString()),
    );

    // Fetch assigned objects and extract their IDs
    final assignedObjects = await _userService.getUserAssignedObjects(int.parse(userId));
    final objectPermissionIds = assignedObjects.map((obj) {
      // Try to parse id as int, fallback to 0 if not possible
      final id = obj['id'];
      return int.tryParse(id.toString()) ?? 0;
    }).where((id) => id != 0).toList();

    debugPrint('Response from fetchUserDetails API : $response');
    debugPrint('Fetched object_permission: $assignedObjects');
    final id = int.tryParse(response['id'].toString()) ?? 0;

    if (id > 0) {
      // Pass object_permission_ids to UserModel
      final userMap = Map<String, dynamic>.from(response);
      userMap['object_permission_ids'] = objectPermissionIds;
      userMap['objectpermissions'] = assignedObjects;
      return UserModel.fromJson(userMap);
    } else {
      return UserModel.empty();
    }
  }

  Future<UserModel> fetchUserDetailsById(int userId) async {
    //debugPrint('User ID from  UserRepository: $userId');
    final response = await _userService.getUserById(
      int.parse(userId.toString()),
    );

    //  debugPrint('Response from fetchUserDetailsById 2: $response');

   final id = int.tryParse(response['id'].toString()) ?? 0;
    if (id > 0) {
      return UserModel.fromJson(response);
    } else {
      return UserModel.empty();
    }
  }

  /// Function to fetch user details based on user ID.
  Future<List<void>> fetchUserOrders(String userId) async {
    return [];
  }

  Future<List<UserModel>> fetchUsersByContractId(int contractId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUsersByContractId(contractId);

      if (responseList.isEmpty) return [];


      debugPrint('Response from fetchUsersByContractId: $responseList');

      return responseList
          .map((bookingData) => UserModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchUsersByContractId: $e');
      return [];
    }
  }

  Future<List<DocsModel>> fetchUserDocsByUserId(int userId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUserDocs(userId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((docData) => DocsModel.fromJson(docData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchUserDocsByUserId: $e');
      return [];
    }
  }


  Future<List<BookingModel>> fetchUserBookingsByUserId(int userId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUserObjectAllBookingsByUserId(userId);

      if (responseList.isEmpty) return [];

      debugPrint('Response from fetchUserBookingsByUserId: $responseList');

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchUserBookingsByUserId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchUserRequestsByContractId(
    int contractId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUserObjectAllRequests(contractId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchUserRequestsByContractId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchUserRequestsByUserId(int userId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUserObjectAllRequestsByUserId(userId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchUserRequestsByUserId: $e');
      return [];
    }
  }

  Future<bool> createUserRequestNotificationByContractId(
    int contractId,
    int requestId,
    int statusId,
    String ticketNumber,
  ) async {
    try {
      final message =
          'Your request ($ticketNumber) has been updated to: ${THelperFunctions.getStatusText(statusId).toUpperCase()}.';

      final result = await _userService
          .createUserContractNotificationAndSendPush(
            contractId,
            2, // request
            message,
            requestId,
          );

      if (result['success'] == false) {
        debugPrint(
          'Error creating user request notification: ${result['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error creating tenant request notification: $e');
      return false;
    }
  }

  /// getUserObjectDocs

  Future<int> quickUserInsert(
    String firstName,
    String lastName,
    String email,
    String phone_number,
    int roleId,
    int companyId,
  ) async {
    try {
      final response = await _userService.createQuickNewUser(
        firstName,
        lastName,
        email,
        phone_number,
        roleId,
        companyId,
      );

      debugPrint('Response from quickUserInsert: $response');

      return response['status'];
    } catch (e) {
      return 2;
    }
  }
  Future<int> quickCompanyInsert(Map<String, dynamic> registrationData) async {
    try {
      final response = await _userService.registerCompany(registrationData);
      debugPrint('Response from Quickregister Company: $response');
      return response['status'];
    } catch (e) {
      return 2;
    }
  }
   Future<bool> quickUserUpdate(
    String firstName,
    String lastName,
    int objectId,
    int userId,
  ) async {
    try {
      final response = await _userService.updateQuickUser(
        firstName,
        lastName,
        objectId,
        userId,
      );
      if (response['success'] == false) {
        debugPrint('Error updating user quick : ${response['message']}');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserRequestStatus(
    int requestId,
    int statusId,
    String comment,
  ) async {
    try {
      // first update the fields
      final result = await _userService.updateUserRequestStatus(
        requestId,
        statusId,
      );

      if (result['success'] == false) {
        debugPrint(
          'Error updating tenant request status : ${result['message']}',
        );
        return false;
      }

      // then update the comment
      final commentResult = await _userService.createUserObjectRequestLog(
        requestId,
        statusId,
        comment,
        int.parse(AuthenticationRepository.instance.currentUser!.id.toString()),
        'agency_user',
      );

      if (commentResult['success'] == false) {
        debugPrint(
          'Error updating user request comment : ${commentResult['message']}',
        );
        return false;
      }
      // If both updates are successful, return true
      debugPrint('User request status and comment updated successfully');

      return true;
    } catch (e) {
      debugPrint('Error updating user request status: $e');
      return false;
    }
  }

  Future<bool> updateUserDetails(UserModel updatedUser) async {
    // display debugPrint of the updated user
    debugPrint('Updated User: ${updatedUser.toJson()}');

    // get editcontroller instance
    final controller = Get.find<UserController>();

    debugPrint(controller.hasImageChanged.value.toString());

    try {
      if (updatedUser.id == null || updatedUser.id!.isEmpty) {
        debugPrint('User ID not found.');
        return false;
      }

      // first check if image has changed or been updated

      String imageUrl = updatedUser.profilePicture ?? '';

      if (controller.hasImageChanged.value) {
        final directoryName =
            "users/${updatedUser.id}";

        try {
          late Map<String, dynamic> imageResponse;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          if (kIsWeb) {
            // WEB: upload directly from bytes
            // get datetime to add to filename
            //${DateTime.now().millisecondsSinceEpoch}

            final bytes = controller.memoryBytes.value!;
            final filename = "user_${updatedUser.id}.jpg";
            imageResponse = await ObjectService().uploadAzureImage(
              bytes: bytes,
              filename: filename,
              id: int.parse(updatedUser.id!),
              containerName: "docs",
              directoryName: directoryName,
            );
          } else {
            // MOBILE/DESKTOP: write to temp file then upload
            final temp = await writeBytesToTempFile(
              controller.memoryBytes.value!,
              'user_${updatedUser.id}.jpg',
            );
            imageResponse = await ObjectService().uploadAzureImage(
              file: temp,
              filename: p.basename(temp.path),
              id: int.parse(updatedUser.id!),
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
            updatedUser.profilePicture = userImageUrl;
          }
        } catch (error) {
          debugPrint("Error uploading image: $error");
        }
      }

      // Update the user details

      debugPrint('User Image URL before updating: $imageUrl');

      final result = await _userService.updateUserPersonalDetails(
        int.parse(updatedUser.id!),
        updatedUser.firstName,
        updatedUser.lastName,
        updatedUser.displayName,
        updatedUser.phoneNumber,
        updatedUser.countryCode,
        updatedUser.profilePicture
      );

      if (result['success'] == false) {
        debugPrint('Error updating user: ${result['message']}');
        return false;
      }

      debugPrint('Update User Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error updating user: $e');
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

  /// Delete User Data
  Future<bool> deleteUserById(int id, [int? objectId]) async {
    try {
      final response = await _userService.deleteUserById(
        id 
      );

      if (response['success'] != true) {
        throw Exception('Failed to delete user: ${response['message']}');
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> updateUserBookingStatus(int bookingId, int statusId) async {
    try {
      final response = await _userService.updateUserObjectBookingStatus(
        bookingId,
        statusId,
      );
      if (response['success'] == false) {
        debugPrint(
          'Error updating user booking status : ${response['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createUserBooking(
    int userId,
    int amenityId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    int contractId,
  ) async {
    try {
      final result = await _userService.createUserObjectBooking(
        userId,
        amenityId,
        bookingDate,
        startTime,
        endTime,
        contractId,
      );

      if (result['success'] == false) {
        debugPrint('Error creating user booking: ${result['message']}');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error creating user request notification: $e');
      return false;
    }
  }

  Future<List<UserRoleModel>> getAllUserRoles() async {
        try {
          final roleId = 2;

      final response = await _userService.getAllUserRoles();

      return response
          .map((userRoleData) => UserRoleModel.fromJson(userRoleData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user roles: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createNewUser(
    String firstName,
    String lastName,
    String email,
    String phoneNumber, 
    int roleId,
    int companyId,
    {String token = ''}
  ) async {
    try {
      final response = await _userService.createQuickNewUser(
        firstName,
        lastName,
        email,
        phoneNumber,  
        roleId,
        companyId,
        token: token,
      );

      // debugPrint('Response from createNewUser: $response');
      return response;
    } catch (e) {
      return {
        'success': false,
        'status': 2,
        'message': 'Error creating new user: $e',
      };
    }
  }

  Future<bool> assignUserToObjectsBatch(
    int userId,
    List<int> objectIds,
  ) async {
    try {
      final response = await _userService.assignUserToObjectsBatch(
        userId,
        objectIds,
      );

      if (response['success'] == false) {
        return false;
      }

      return true;
    } catch (error) {
      debugPrint("Error in assignUnitsBatch: $error");
      return false;
    }
  }

  Future<List<ObjectModel>> getUserAssignedObjects(int userId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUserAssignedObjects(userId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => ObjectModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in getUserAssignedObjects: $e');
      return [];
    }
  }

  Future<bool> deleteAllUserAssignedObjects(int userId) async {
    try {
      final response = await _userService.deleteAllUserAssignedObjects(
        userId,
      );

      if (response['success'] != true) {
        throw Exception(
          'Failed to delete all user assigned objects: ${response['message']}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting all user assigned objects: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> deleteUserDirectory(String container, directory) async {
    try {
      final response = await _userService.deleteUserDirectory(
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

  Future<String> createUserInviationCode(String email, int userId) async {
    try {
      final response = await _userService.createUserInvitationCode(
        email,
        userId,
      );

      return response['data'][0]['token'] ?? '';
    } catch (e) {
      return '';
    }
  }
  Future<String> updateTokenByUser(String email, int userId) async {
    try {
      final response = await _userService.updateTokenByUser(
        userId,
        email
       
      );  

      return response['data'][0]['token'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<String> createUserInvitationCode(
    String email,
    int userId
  ) async {
    try {
      final response = await _userService.createUserInvitationCode(
        email,
        userId 
      );

      return response['data'][0]['token'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<bool> sendUserInviationCodeEmail(
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
      final response = await _userService.sendUserInvitationEmail(
        greetings,
        bodyText,
        invitationCodeText,
        invitationCode,
        availableOnText,
        helpText,
        supportText,
        subject,
        email,
      );

      if (response['success'] != true) {
        debugPrint(
          'Error sending user invitation email: ${response['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendUserInvitationCodeEmail(
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
      final response = await _userService.sendUserInvitationEmail(
        greetings,
        bodyText,
        invitationCodeText,
        invitationCode,
        availableOnText,
        helpText,
        supportText,
        subject,
        email,
      );

      if (response['success'] != true) {
        debugPrint(
          'Error sending user invitation email: ${response['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserInvitationStatus(int id, int statusId) async {
    try {
      final response = await _userService.updateUserInvitationStatus(
        id,
        statusId,
      );
      if (response['success'] == false) {
        debugPrint(
          'Error updating user invitation status : ${response['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserStatus(int id, int statusId) async {
    try {
      final response = await _userService.updateUserStatus(id, statusId);
      if (response['success'] == false) {
        debugPrint('Error updating user status : ${response['message']}');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserObjectStatus(
    int userId,
    int statusId,
    int objectId,
  ) async {
    try {
      final response = await _userService.updateUserObjectStatus(
        userId,
        statusId,
        objectId,
      );
      if (response['success'] == false) {
        debugPrint('Error updating user status : ${response['message']}');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
