import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:xm_frontend/data/api/services/building_service.dart';
import 'package:xm_frontend/data/api/services/user_service.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
import 'package:xm_frontend/data/models/request_log_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/user_role_model.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';
import 'package:path/path.dart' as p;

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final UserService _userService = Get.put(UserService()); // Inject Service

  /// Function to fetch user details based on user ID.
  Future<List<UserModel>> getAllUsers() async {
    return [];
  }

  Future<List<UserModel>> getAllBuildingTenants(String buildingId) async {
    try {
      if (buildingId == null || buildingId.isEmpty) {
        debugPrint('Agency ID not found.');
        return [];
      }

      final response = await _userService.getTenantsByBuildingId(
        int.parse(buildingId),
      );

      return response
          .map((tenantData) => UserModel.fromJson(tenantData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching tenants: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllAgencyBuildingTenants() async {
    try {
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;

      if (agencyId == null || agencyId.isEmpty) {
        debugPrint('Agency ID not found.');
        return [];
      }

      final response = await _userService.getTenantsByAgencyId(
        int.parse(agencyId),
      );

      return response
          .map((tenantData) => UserModel.fromJson(tenantData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching tenants: $e');
      return [];
    }
  }

  Future<List<UserModel>> getAllAgencyUsers() async {
    try {
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;

      if (agencyId == null || agencyId.isEmpty) {
        debugPrint('Agency ID not found.');
        return [];
      }

      final response = await _userService.getUsersByAgencyId(
        int.parse(agencyId),
      );

      return response.map((userData) => UserModel.fromJson(userData)).toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
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

    final response = await _userService.getCompanyById(
      int.parse(userId.toString()),
    );

    debugPrint('Response from fetchUserDetails API : $response');

    if (response['id'] > 0) {
      return UserModel.fromJson(response);
    } else {
      return UserModel.empty();
    }
  }

  Future<UserModel> fetchUserDetailsById(int userId) async {
    //debugPrint('User ID from  UserRepository: $userId');
    final response = await _userService.getCompanyById(
      int.parse(userId.toString()),
    );

    //  debugPrint('Response from fetchUserDetailsById 2: $response');

    if (response['id'] > 0) {
      return UserModel.fromJson(response);
    } else {
      return UserModel.empty();
    }
  }

  /// Function to fetch user details based on user ID.
  Future<List<void>> fetchUserOrders(String userId) async {
    return [];
  }

  Future<List<UserModel>> fetchTenantsByContractId(int contractId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getTenantsByContractId(contractId);

      if (responseList.isEmpty) return [];

      //   debugPrint('Response from fetchTenantsByContractId: $responseList');
      //   debugPrint('Response from fetchTenantsByContractId: ${responseList.length}');

      debugPrint('Response from fetchTenantsByContractId: $responseList');

      return responseList
          .map((bookingData) => UserModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchTenantsByContractId: $e');
      return [];
    }
  }

  Future<List<DocsModel>> fetchTenantDocsByContractId(int contractId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getTenantBuildingDocs(contractId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((docData) => DocsModel.fromJson(docData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchTenantDocsByContractId: $e');
      return [];
    }
  }

  Future<List<BookingModel>> fetchTenantBookingsByContractId(
    int contractId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getTenantBuildingAllBookings(contractId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchTenantBookingsByContractId: $e');
      return [];
    }
  }

  Future<List<BookingModel>> fetchTenantBookingsByTenantId(int tenantId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getTenantBuildingAllBookingsByTenantId(tenantId);

      if (responseList.isEmpty) return [];

      debugPrint('Response from fetchTenantBookingsByTenantId: $responseList');

      return responseList
          .map((bookingData) => BookingModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchTenantBookingsByTenantId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchTenantRequestsByContractId(
    int contractId,
  ) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getTenantBuildingAllRequests(contractId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchTenantRequestsByContractId: $e');
      return [];
    }
  }

  Future<List<RequestModel>> fetchTenantRequestsByTenantId(int tenantId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getTenantBuildingAllRequestsByTenantId(tenantId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => RequestModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchTenantRequestsByTenantId: $e');
      return [];
    }
  }

  Future<bool> createTenantRequestNotificationByContractId(
    int contractId,
    int requestId,
    int statusId,
    String ticketNumber,
  ) async {
    try {
      final message =
          'Your request ($ticketNumber) has been updated to: ${THelperFunctions.getStatusText(statusId).toUpperCase()}.';

      final result = await _userService
          .createTenantContractNotificationAndSendPush(
            contractId,
            2, // request
            message,
            requestId,
          );

      if (result['success'] == false) {
        debugPrint(
          'Error creating tenant request notification: ${result['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error creating tenant request notification: $e');
      return false;
    }
  }

  /// getTenantBuildingDocs

  Future<int> quickTenantInsert(
    String firstName,
    String lastName,
    String email,
    int buildingId,
    int createdById,
  ) async {
    try {
      final response = await _userService.createQuickNewTenant(
        firstName,
        lastName,
        email,
        buildingId,
        createdById,
      );

      debugPrint('Response from quickTenantInsert: $response');

      return response['status'];
    } catch (e) {
      return 2;
    }
  }

  Future<bool> quickTenantUpdate(
    String firstName,
    String lastName,
    int buildingId,
    int tenantId,
  ) async {
    try {
      final response = await _userService.updateQuickTenant(
        firstName,
        lastName,
        buildingId,
        tenantId,
      );
      if (response['success'] == false) {
        debugPrint('Error updating tenant quick : ${response['message']}');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTenantRequestStatus(
    int requestId,
    int statusId,
    String comment,
  ) async {
    try {
      // first update the fields
      final result = await _userService.updateTenantRequestStatus(
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
      final commentResult = await _userService.createTenantBuildingRequestLog(
        requestId,
        statusId,
        comment,
        int.parse(AuthenticationRepository.instance.currentUser!.id.toString()),
        'agency_user',
      );

      if (commentResult['success'] == false) {
        debugPrint(
          'Error updating tenant request comment : ${commentResult['message']}',
        );
        return false;
      }
      // If both updates are successful, return true
      debugPrint('Tenant request status and comment updated successfully');

      return true;
    } catch (e) {
      debugPrint('Error updating tenant request status: $e');
      return false;
    }
  }

  Future<bool> updateUserDetails(UserModel updatedUser) async {
    // display debugPrint of the updated user
    debugPrint('Updated User: ${updatedUser.toJson()}');

    // get editcontroller instance
    final controller = Get.put(UserController());

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
            "agencies/${updatedUser.agencyId}/users/${updatedUser.id}";

        try {
          late Map<String, dynamic> imageResponse;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          if (kIsWeb) {
            // WEB: upload directly from bytes
            // get datetime to add to filename
            //${DateTime.now().millisecondsSinceEpoch}

            final bytes = controller.memoryBytes.value!;
            final filename = "user_${updatedUser.id}_$timestamp.jpg";
            imageResponse = await BuildingService().uploadAzureImage(
              bytes: bytes,
              filename: filename,
              id: int.parse(updatedUser.id!),
              containerName: "media",
              directoryName: directoryName,
            );
          } else {
            // MOBILE/DESKTOP: write to temp file then upload
            final temp = await writeBytesToTempFile(
              controller.memoryBytes.value!,
              'user_${updatedUser.id}_$timestamp.jpg',
            );
            imageResponse = await BuildingService().uploadAzureImage(
              file: temp,
              filename: p.basename(temp.path),
              id: int.parse(updatedUser.id!),
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
        updatedUser.profilePicture,
        updatedUser.roleExtId!,
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
  Future<bool> deleteTenantById(int id, int buildingId) async {
    try {
      final response = await _userService.deleteTenantBuildingTenant(
        id,
        buildingId,
      );

      if (response['success'] != true) {
        throw Exception('Failed to delete tenant: ${response['message']}');
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting tenant: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> updateTenantBookingStatus(int bookingId, int statusId) async {
    try {
      final response = await _userService.updateTenantBuildingBookingStatus(
        bookingId,
        statusId,
      );
      if (response['success'] == false) {
        debugPrint(
          'Error updating tenant booking status : ${response['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createTenantBooking(
    int tenantId,
    int amenityId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    int contractId,
  ) async {
    try {
      final result = await _userService.createTenantBuildingBooking(
        tenantId,
        amenityId,
        bookingDate,
        startTime,
        endTime,
        contractId,
      );

      if (result['success'] == false) {
        debugPrint('Error creating tenant booking: ${result['message']}');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error creating tenant request notification: $e');
      return false;
    }
  }

  Future<List<UserRoleModel>> getAllUserRoles() async {
    try {
      final roleId = 2;

      final response = await _userService.getUserRolesByRoleId(roleId);

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
    int roleId,
    int roleExtId,
    int agencyId,
  ) async {
    try {
      final response = await _userService.createNewUser(
        firstName,
        lastName,
        email,
        roleId,
        roleExtId,
        agencyId,
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

  Future<bool> assignUserToBuildingsBatch(
    int userId,
    List<int> buildingIds,
  ) async {
    try {
      final response = await _userService.assignUserToBuildingsBatch(
        userId,
        buildingIds,
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

  Future<List<BuildingModel>> getUserAssignedBuildings(int userId) async {
    try {
      final List<Map<String, dynamic>> responseList = await _userService
          .getUserAssignedBuildings(userId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((requestData) => BuildingModel.fromJson(requestData))
          .toList();
    } catch (e) {
      debugPrint('Error in getUserAssignedBuildings: $e');
      return [];
    }
  }

  Future<bool> deleteAllUserAssignedBuildings(int userId) async {
    try {
      final response = await _userService.deleteAllUserAssignedBuildings(
        userId,
      );

      if (response['success'] != true) {
        throw Exception(
          'Failed to delete all user assigned buildings: ${response['message']}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting all user assigned buildings: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> deleteUserById(int id) async {
    try {
      final response = await _userService.deleteUserById(id);

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

  Future<String> createTenantInviationCode(
    String email,
    int userId,
    int contractId,
  ) async {
    try {
      final response = await _userService.createTenantInvitationCode(
        email,
        userId,
        contractId,
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

  Future<bool> sendTenantInviationCodeEmail(
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
      final response = await _userService.sendTenantInvitationEmail(
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
          'Error sending tenant invitation email: ${response['message']}',
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

  Future<bool> updateTenantBuildingStatus(
    int tenantId,
    int statusId,
    int buildingId,
  ) async {
    try {
      final response = await _userService.updateTenantBuildingStatus(
        tenantId,
        statusId,
        buildingId,
      );
      if (response['success'] == false) {
        debugPrint('Error updating tenant status : ${response['message']}');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
