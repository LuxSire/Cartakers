import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/api/services/agency_service.dart';

import 'package:xm_frontend/data/models/message_model.dart';

import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';

/// Repository class for user-related operations.
class AgencyRepository extends GetxController {
  static AgencyRepository get instance => Get.find();

  final _agencyService = AgencyService();

  Future<List<MessageModel>> fetchAllAgencyMessages() async {
    try {
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;

      final List<Map<String, dynamic>> responseList = await _agencyService
          .getAllAgencyMessages(int.parse(agencyId));

      if (responseList.isEmpty) return [];

      return responseList
          .map((bookingData) => MessageModel.fromJson(bookingData))
          .toList();
    } catch (e) {
      debugPrint('Error in fetchAllAgencyMessages: $e');
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
      // if your API needs agencyId or userId in the URL, grab it here:
      final agencyId = AuthenticationRepository.instance.currentUser!.agencyId;
      await _agencyService.sendMessage(int.parse(agencyId), payload);
    } catch (e, st) {
      debugPrint('Error in sendMessage: $e\n$st');
      rethrow;
    }
  }

  Future<bool> deleteAgecyMessage(int id) async {
    try {
      final response = await _agencyService.deleteAgencyMessage(id);

      if (response['success'] != true) {
        throw Exception(
          'Failed to delete agency message: ${response['message']}',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting agency message: $e');
      return false;
      //rethrow;
    }
  }
}
