import 'package:flutter/material.dart';

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

  Future<Map<String, dynamic>> sendMessage(
    int companyId,
    Map<String, dynamic> payload,
  ) async {
    try {
      // Build request body including company _id key
      final body = {'company_id': companyId, ...payload};

      // POST to your create‐message endpoint
      final response = await post(ApiEndpoints.createCompanyMessage, body);

      return response as Map<String, dynamic>;
    } catch (error, stack) {
      debugPrint('Error in sendMessage: $error\n$stack');
      rethrow;
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
