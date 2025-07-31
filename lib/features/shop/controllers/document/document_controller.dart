import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/amenity_zone_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/models/amenity_zone_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class DocumentController extends GetxController {
  static DocumentController get instance => Get.find();

  final int contractId;
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final renameDocumentController = TextEditingController();

  final loading = false.obs;
  final selectedZoneId = RxnInt();
  final docs = <DocsModel>[].obs;
  final allDocs = <DocsModel>[].obs;
  final filteredDocs = <DocsModel>[].obs;

  DocumentController({required this.contractId});

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      loading.value = true;
      docs.clear();

      filteredDocs.clear();

      // Load zones
      selectedZoneId.value = null;

      debugPrint('Contract ID from load: $contractId');

      docs.assignAll(
        await UserRepository.instance.fetchUserDocsByContractId(contractId),
      );

      debugPrint('Docs: ${docs.length}');

      filteredDocs.assignAll(docs);
    } finally {
      loading.value = false;
    }
  }

  void openDocument(String fileUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${fileUrl.split('/').last}';

      File file = File(filePath);

      // Download the file if it doesn't already exist
      if (!file.existsSync()) {
        debugPrint("Downloading file...");
        final response = await http.get(Uri.parse(fileUrl));
        await file.writeAsBytes(response.bodyBytes);
      }

      debugPrint("Opening downloaded file: $filePath");

      // Open the file with the associated app
      final result = await OpenFile.open(filePath);
      debugPrint("OpenFile result: ${result.type}, Message: ${result.message}");
    } catch (e) {
      debugPrint("Error opening document: $e");
    }
  }

  void filterDocs(String query) {
    if (query.isEmpty) {
      filteredDocs.assignAll(docs);
    } else {
      filteredDocs.assignAll(
        docs.where(
          (doc) =>
              doc.fileName?.toLowerCase().contains(query.toLowerCase()) ??
              false,
        ),
      );
    }
  }
}
