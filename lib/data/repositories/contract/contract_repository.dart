import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/api/services/object_service.dart';
import 'package:xm_frontend/data/api/services/user_service.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

/// Repository class for user-related operations.
class ContractRepository extends GetxController {
  static ContractRepository get instance => Get.find();

  final _objectService = ObjectService();
  final _userService = UserService();

  /// Function to save contract data to database.

  ///
  Future<List<UserModel>> getAllNonContractUsers(int objectId) async {
    try {
      final response = await _objectService
          .getAllNonContractUsersByObjectId(
            int.parse(objectId.toString()),
          );

      return response
          .map((tenantData) => UserModel.fromJson(tenantData))
          .toList();
    } catch (e) {
      debugPrint('Error fetching non contract users: $e');
      return [];
    }
  }

  Future<ContractModel> fetchContractById(int contractId) async {
    try {
      final contract = await _objectService.fetchContractById(contractId);
      if (contract == null) throw Exception('Contract not found');
      return contract;
    } catch (e) {
      debugPrint('Error fetching contract: $e');
      rethrow;
    }
  }

  Future<ContractModel> fetchActiveContractsByUnitId(int unitId) async {
    try {
      final contract = await _objectService.fetchActiveContractByUnitId(
        unitId,
      );
      if (contract == null) {
        debugPrint('No active contract found for unit ID: $unitId');
        return ContractModel.empty();
      }
      return contract;
    } catch (e) {
      // If this is a 404, return empty instead of throwing
      if (e.toString().contains('DioException') &&
          e.toString().contains('404')) {
        debugPrint(
          'No active contract found for unit ID: $unitId (Handled 404)',
        );
        return ContractModel.empty();
      }

      debugPrint('Error fetching contract: $e');
      rethrow;
    }
  }

  Future<bool> updateContractDetails(ContractModel updatedContract) async {
    try {
      // first update the fields
      final result = await _objectService.updateContractDetails(
        int.parse(updatedContract.id!),
        updatedContract.contractCode!,
        updatedContract.startDate,
        updatedContract.endDate,
        updatedContract.statusId!,
      );

      // update the tenants

      if (updatedContract.users != null) {
        // remove all tenants from contract
        await _objectService.deleteUsersFromContract(
          int.parse(updatedContract.id!),
        );

        for (var tenant in updatedContract.users!) {
          // set first tenant as primary
          var isPrimary = 0;
          if (updatedContract.users!.indexOf(tenant) == 0) {
            isPrimary = 1;
          }
          await _objectService.addUserToContract(
            int.parse(updatedContract.id!),
            int.parse(tenant.id!),

            isPrimary,
          );
        }
      }

      if (result['success'] == false) {
        debugPrint('Error updating contract : ${result['message']}');
        return false;
      }

      //   debugPrint('Update contract Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error updating contract: $e');
      return false;
    }
  }

  Future<bool> removeUserFromContract(int contractId, int userId) async {
    try {
      // first update the fields
      final result = await _objectService.removeUserFromContract(
        contractId,
        userId,
      );

      if (result['success'] == false) {
        debugPrint(
          'Error removing user from  contract : ${result['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error removing user from contract: $e');
      return false;
    }
  }

  Future<bool> updateUserContractPrimary(int contractId, int userId) async {
    try {
      // first update the fields
      final result = await _userService.updateUserContractPrimary(
        contractId,
        userId,
      );

      if (result['success'] == false) {
        debugPrint(
          'Error updating user   contract primary : ${result['message']}',
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error updating user contract primary: $e');
      return false;
    }
  }

  Future<bool> createContract(ContractModel contract) async {
    try {
      // first update the fields
      final result = await _objectService.createContract(
        contract.contractCode!,
        contract.startDate,
        contract.statusId!,
        contract.unitId!,
        contract.objectId!,
      );

      final contractId = result['data'][0]['contract_id'];

      // add the users
      for (var user in contract.users!) {
        // set first user as primary
        var isPrimary = 0;
        if (contract.users!.indexOf(user) == 0) {
          isPrimary = 1;
        }

        await _objectService.addUserToContract(
          int.parse(contractId.toString()),
          int.parse(user.id!),

          isPrimary,
        );
      }

      if (result['success'] == false) {
        debugPrint('Error updating contract : ${result['message']}');
        return false;
      }

      //   debugPrint('Update contract Result: $result');

      return true;
    } catch (e) {
      debugPrint('Error submitting a new contract: $e');
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

  Future<List<DocsModel>> getAllDocumentsByContractId(int contractId) async {
    try {
      final response = await _objectService
          .getAllNonContractUsersByObjectId(
            int.parse(contractId.toString()),
          );

      return response.map((docData) => DocsModel.fromJson(docData)).toList();
    } catch (e) {
      debugPrint('Error fetching contract documents: $e');
      return [];
    }
  }

  Future<bool> uploadNewDocument(
    int contractId,
    String directoryName,
    File pickedFile,
  ) async {
    try {
      // Now, we call the uploadAzureDocument function to upload the selected file
      

      // final get file name
      final fileName = path.basename(pickedFile.path);
      // remove the extension
      final fileNameWithoutExtension = fileName.substring(
        0,
        fileName.lastIndexOf('.'),
      );
      // final fileExtension = fileName.substring(fileName.lastIndexOf('.'));
      final creatorId = AuthenticationRepository.instance.currentUser!.id;
      if (creatorId == null) {
        debugPrint("Creator ID is null");
        return false;
      }


      return true;
    } catch (e) {
      debugPrint('Error uploading document: $e');
      return false;
    }
  }

  Future<bool> deleteDocument(
    String docName,
    String containerName,
    String directoryName,
  ) async {
    try {
      final documentResponse = await _objectService.deleteDocumentFromAzure(
        fileName: docName,
        containerName: containerName,
        directoryName: directoryName, 
      );

      if (documentResponse['success'] == false) {
        debugPrint("Failed to delete document: ${documentResponse['message']}");
        return false;
      } else {
        // now let's delete the record in the datdabase

      }

      return true;
    } catch (e) {
      debugPrint('Error deleting document: $e');
      return false;
    }
  }

  Future<bool> updateFileName(String documentId, String newFileName) async {
    try {
      final documentResponse = await _objectService.updateFileName(
        documentId,
        newFileName,
      );

      if (documentResponse['success'] == false) {
        debugPrint(
          "Failed to update file name: ${documentResponse['message']}",
        );
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error update file name: $e');
      return false;
    }
  }

  Future<List<ContractModel>> getContractsByObjectId(int objectId) async {
    try {
      return [];
    } catch (e) {
      debugPrint('Error fetching contracts by object ID: $e');
      return [];
    }
  }

  Future<List<ContractModel>> getAllCompanyObjectsContracts() async {
    try {
      return [];
    } catch (e) {
      debugPrint('Error fetching company object contracts: $e');
      return [];
    }
  }

  /// Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {}

  /// Delete  Data
  Future<bool> deleteContract(int id) async {
    try {
      final response = await _objectService.deleteContractById(id);

      if (response['success'] == false) {
        debugPrint('Error deleting contract: ${response['message']}');

        debugPrint('Error deleting contract: ${response['sqlMessage']}');

        if (response['sqlMessage'].toString().contains('tbl_tenant_docs')) {
          // display snackbar

          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(Get.context!).translate(
              'contract_screen.msg_cannot_delete_contract_because_there_are_still_documents_present',
            ),
          );
        }

        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting contract: $e');
      return false;
    }
  }
}
