import 'package:flutter/material.dart';

import 'base_service.dart';
import '../api_endpoints.dart';

class AgencyService extends BaseService {
  Future<List<Map<String, dynamic>>> getAllAgencyMessages(int agencyId) async {
    try {
      final response = await post(ApiEndpoints.getAllAgencyMessages, {
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

  Future<Map<String, dynamic>> sendMessage(
    int agencyId,
    Map<String, dynamic> payload,
  ) async {
    try {
      // Build request body including agency_id key
      final body = {'agency_id': agencyId, ...payload};

      // POST to your create‐message endpoint
      final response = await post(ApiEndpoints.createAgencyMessage, body);

      return response as Map<String, dynamic>;
    } catch (error, stack) {
      debugPrint('Error in sendMessage: $error\n$stack');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteAgencyMessage(int messageId) async {
    try {
      final response = await post(ApiEndpoints.deleteAgencyMessage, {
        'message_id': messageId,
      });

      return response;
    } catch (error) {
      debugPrint("Error in deleteAgencyMessage: $error");
      return {"success": false, "message": "Failed to delete agency message"};
    }
  }
}
