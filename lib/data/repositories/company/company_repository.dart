import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cartakers/data/api/services/company_service.dart';

import 'package:cartakers/data/models/message_model.dart';

import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/features/personalization/models/company_model.dart';

/// Repository class for user-related operations.
class CompanyRepository extends GetxController {
  static CompanyRepository get instance => Get.find();

  final _companyService = CompanyService();

  /// Function to fetch user details based on user ID.
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final response = await _companyService.getAllCompanies();
         final List<dynamic> companiesJson = response['data'];
    return companiesJson
        .map((companyData) => CompanyModel.fromJson(companyData as Map<String, dynamic>))
        .toList();
  } catch (e) {
    debugPrint('Error fetching companies from getAllCompanies: $e');
    return [];
  }
  }


  Future<List<MessageModel>> fetchAllCompanyMessages() async {
    try {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;

      final List<Map<String, dynamic>> responseList = await _companyService
          .getAllCompanyMessages( companyId);

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => MessageModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchAllCompanyMessages: $e');
      return [];
    }
  }
  Future<Map<String, dynamic>> createNewCompany(
    String Name,
    String email,
    String phoneNumber, 
    String city,
    String country,
    int roleId

  ) async {
    try {
      final response = await _companyService.createQuickNewCompany(
        Name,
        email,
        phoneNumber,
        city,
        country,
        roleId
        
      );

      return response;
    } catch (e) {
      return {
        'success': false,
        'status': 2,
        'message': 'Error creating new company: $e',
      };
    }
  } 
  
/*
  Future<Map<String, dynamic>> createNewCompany(
    String Name,
    String email,
    String phoneNumber, 
    int roleId,
    int companyId
  ) async {
    try {
      final response = await _companyService.registerCompany(
        Name,
        email,
        phoneNumber,  
        roleId,
        companyId
      );

      // debugPrint('Response from createNewUser: $response');
      return response;
    } catch (e) {
      return {
        'success': false,
        'status': 2,
        'message': 'Error creating new company: $e',
      };
    }
  }
*/

    /// Function to fetch user details based on user ID.
  Future<CompanyModel> fetchCompanyDetails() async {
    var userId = '0';

    try {
      userId = AuthenticationRepository.instance.currentUser!.id.toString();
    } catch (e) {
      debugPrint('Error: $e');
      return CompanyModel.empty();
    }

    final response = await _companyService.getCompanyById(
      int.parse(userId.toString()),
    );
 
    debugPrint('Response from fetchUserDetails API : $response');
    final id = int.tryParse(response['id'].toString()) ?? 0;

    if (id > 0) {
      // Pass object_permission_ids to UserModel
      final userMap = Map<String, dynamic>.from(response);
      return CompanyModel.fromJson(userMap);
    } else {
      return CompanyModel.empty();
    }
  }
  Future<int> registerupdateCompany(CompanyModel companyModel) async {
    try {
      final response = await _companyService.registerupdateCompany(companyModel);
      debugPrint('Response from register Company: $response');
      return response['status'];
    } catch (e) {
      return 2;
    }
  }

  Future<CompanyModel> fetchCompanyDetailsById(int companyId) async {
    //debugPrint('User ID from  UserRepository: $userId');
    final response = await _companyService.getCompanyById(
      int.parse(companyId.toString()),
    );

    //  debugPrint('Response from fetchUserDetailsById 2: $response');

   final id = int.tryParse(response['id'].toString()) ?? 0;
    if (id > 0) {
      return CompanyModel.fromJson(response);
    } else {
      return CompanyModel.empty();
    }
  }

  Future<bool> quickCompanyUpdate(
    String firstName,
    String lastName,
    int objectId,
    int userId,
  ) async {
    try {
      final response = await _companyService.updateQuickCompany(
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


  /// Sends a new message (or schedules it) via the backend.
  ///
  /// Expects `payload` to contain:
  ///  - title: String
  ///  - content: String
  ///  - channels: List<String>
  ///  - scheduleAt: String? (ISO timestamp) or null
  ///  - targets: List<Map<String, dynamic>> (your buildings/contracts JSON)
  Future<void> sendMessage(Map<String, dynamic> payload) async {
    try {
      // if your API needs companyId or userId in the URL, grab it here:
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;
      await _companyService.sendMessage( companyId, payload);
    } catch (e, st) {
      debugPrint('Error in sendMessage: $e\n$st');
      rethrow;
    }
  }


  /// Delete User Data
  Future<bool> deleteCompanyById(int id, [int? companyId]) async {
    try {
      final response = await _companyService.deleteCompanyById(
        id,
      );

      if (response['success'] != true) {
        throw Exception('Failed to delete company: ${response['message']}');
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
      //rethrow;
    }
  }

  Future<bool> deleteCompanyMessage(int id) async {
    try {
      final response = await _companyService.deleteCompanyMessage(id);

      if (response['success'] != true) {
        throw Exception(
          'Failed to delete company message: ${response['message']}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting company message: $e');
      return false;
      //rethrow;
    }
  }
}
