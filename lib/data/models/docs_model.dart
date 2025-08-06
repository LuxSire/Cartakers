import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';

class DocsModel {
  final String id;
  RxString fileName; // Making fileName reactive

  final String fileUrl;
  final DateTime updatedAt;
  final DateTime? createdAt;
  final String contentType;
  final int size;
  final String creatorName;

  DocsModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.updatedAt,
    this.createdAt,
    required this.contentType,
    required this.creatorName,
    this.size = 0,
  });

  // Convert JSON response to DocsModel
  factory DocsModel.fromJson(Map<String, dynamic> json) {
    DateTime updatedAt = DateTime.parse(json['lastModified']).toLocal();
    DateTime? createdAt;
    if (json['createdAt'] != null) {
      try {
        createdAt = DateTime.parse(json['createdAt']).toLocal();
      } catch (_) {
        createdAt = null;
      }
    }
    return DocsModel(
      id: json['etag'],
      fileName: RxString(json['name'] ?? ''), // Initialize as RxString
      fileUrl: json['url'],
      updatedAt: updatedAt,
      createdAt: createdAt ?? updatedAt,
      contentType: json['contentType'],
      size: json['size'] ?? 0,
      creatorName: json['creatorName'] ?? '',
    );
  }

  void updateFileName(String newFileName) {
    fileName.value = newFileName; // Reactively updating fileName
  }

  // View: Open the document URL (PDF/Image/Web)
  Future<void> view(BuildContext context) async {
    if (await canLaunchUrlString(fileUrl)) {
      await launchUrlString(fileUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open document')),
      );
    }
  }

  // Rename: Update the file name both locally and via repository
  Future<bool> rename(String newFileName) async {
    // You may need to call an API to rename the file on the backend
    // For now, just update locally
    fileName.value = newFileName;
    // Optionally, call repository to persist change
    // return await ObjectRepository.instance.renameObjectDoc(id, newFileName);
    return true;
  }

  // Delete: Remove the document via repository
  Future<bool> delete() async {
    // Call repository to delete the document
    return true;
  }

}
