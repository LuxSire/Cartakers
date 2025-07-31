import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/api/services/company_service.dart';

import 'package:xm_frontend/data/models/message_model.dart';

import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';

/// Repository class for user-related operations.
class CompanyRepository extends GetxController {
  static CompanyRepository get instance => Get.find();

  final _companyService = CompanyService();

  Future<List<MessageModel>> fetchAllCompanyMessages() async {
    try {
      final companyId = AuthenticationRepository.instance.currentUser!.companyId;

      final List<Map<String, dynamic>> responseList = await _companyService
          .getAllCompanyMessages(int.parse(companyId));

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => MessageModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchAllCompanyMessages: $e');
      return [];
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
      await _companyService.sendMessage(int.parse(companyId), payload);
    } catch (e, st) {
      debugPrint('Error in sendMessage: $e\n$st');
      rethrow;
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
