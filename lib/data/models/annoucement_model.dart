import 'package:xm_frontend/data/api/translation_api.dart';

class AnnoucementModel {
  final int id;
  final int buildingId;
  final String title;
  final String createdAt;
  final String content;

  AnnoucementModel({
    required this.id,
    required this.buildingId,
    required this.title,
    required this.createdAt,
    required this.content,
  });

  // Convert JSON response to AnnoucementModel
  factory AnnoucementModel.fromJson(Map<String, dynamic> json) {
    return AnnoucementModel(
      id: json['id'],
      buildingId: json['building_id'],
      title: json['title'],
      createdAt: json['created_at'] ?? DateTime.now(),
      content: json['content'],
    );
  }

  Future<String> translateTitle() async {
    return await TranslationApi.smartTranslate(title);
  }

  Future<String> translateContent() async {
    return await TranslationApi.smartTranslate(content);
  }
}
