import 'package:flutter/material.dart';
import 'package:cartakers/features/personalization/models/company_model.dart';

import 'base_service.dart';
import '../api_endpoints.dart';

class CompanyService extends BaseService {
  Future<List<Map<String, dynamic>>> getAllCompanyMessages(int companyId) async {
    try {
      final response = await post(ApiEndpoints.getAllCompanyMessages, {
        'company_id': companyId,
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

  Future<Map<String, dynamic>> updateQuickCompany(
    String name,
    String address,
    int objectId,
    int userId,
  ) async {
    try {
      final response = await post(ApiEndpoints.updateQuickCompany, {
        'name': name,
        'address': address,
        'object_id': objectId,
        'user_id': userId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in updateQuickCompany: $error");
      return {"success": false, "message": "Failed to update quick company"};
    }
  }

  Future<Map<String, dynamic>> sendMessage(
    int companyId,
    Map<String, dynamic> payload,
  ) async {
    try {
      // Build request body including company _id key
      final body = {'company_id': companyId, ...payload};

      // POST to your create‐message endpoint
      final response = await post(ApiEndpoints.createChatCompanyMessage, body);

      return response as Map<String, dynamic>;
    } catch (error, stack) {
      debugPrint('Error in sendMessage: $error\n$stack');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAllCompanies() async {
    try {
      final response = await post(ApiEndpoints.getAllCompanies, {
   
      });

      return response;
    } catch (error) {
      debugPrint("Error in getAllCompanies: $error");
      return {"success": false, "message": "Failed to get all companies"};
    }
  }


    Future<Map<String, dynamic>> getCompanyByEmail(String email) async {
    try {
      final response = await post(ApiEndpoints.getCompanyByEmail, {
        'email': email,
      });

      debugPrint('Company Service: getCompanyByEmail: $response');

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

      debugPrint('Company Service: getCompanyById : $response');

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

  Future<Map<String, dynamic>> createQuickNewCompany(
    String name,
    String email,
    String phone_number,
    String city,
    String country,
    int roleId
  ) async {
    try {
      final response = await post(ApiEndpoints.createQuickNewCompany, {
        'name': name,
        'email': email,
        'phone_number': phone_number,
        'city': city,
        'country': country,
        'role_id': roleId ?? 2,
      });

      return response;
    } catch (error) {
      debugPrint("Error in quickCreateNewCompany: $error");
      return {"success": false, "message": "Failed to create new company"};
    }
  }

   


  Future<Map<String, dynamic>> registerupdateCompany(
    CompanyModel registrationData,
  ) async {
    try {
      final response = await post(ApiEndpoints.registerupdateCompany, {
        'company': registrationData.toJson(),
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
  Future<Map<String, dynamic>> deleteCompanyById(int companyId  ) async {
    try {
      debugPrint("Deleting company with ID: $companyId");
      final response = await post(ApiEndpoints.deleteCompanyById, {
        'company_id': companyId.toString(),
      });

      return response;
    } catch (error) { 
      debugPrint("Error in deleteCompanyById: $error");
      return {"success": false, "message": "Failed to delete company"};
    }
  }
  Future<Map<String, dynamic>> deleteCompanyMessage(int messageId) async {
    try {
      final response = await post(ApiEndpoints.deleteCompanyMessage, {
        'message_id': messageId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteCompanyMessage: $error");
      return {"success": false, "message": "Failed to delete company message"};
    }
  }
}
