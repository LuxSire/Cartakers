import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DocsModel {
  final int id;
  final int contractId;
  RxString fileName; // Making fileName reactive

  final String fileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int creatorId;
  final String creatorName;
  final String creatorType;

  DocsModel({
    required this.id,
    required this.contractId,
    required this.fileName,
    required this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.creatorId,
    required this.creatorName,
    required this.creatorType,
  });

  // Convert JSON response to RequestModel
  factory DocsModel.fromJson(Map<String, dynamic> json) {
    return DocsModel(
      id: json['id'],
      contractId: json['contract_id'],
      fileName: RxString(json['file_name'] ?? ''), // Initialize as RxString
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
      creatorId: json['creator_id'],
      creatorName: json['creator_name'],
      creatorType: json['creator_type'],
    );
  }

  void updateFileName(String newFileName) {
    fileName.value = newFileName; // Reactively updating fileName
  }
}
