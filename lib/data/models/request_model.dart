import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class RequestModel {
  final String? id;
  final String? ticketNumber;
  String? requestType;
  int? requestTypeId;
  DateTime? createdAt;
  String? description;
  int? status; // 1 - Pending, 2 - In Progress, 3 - Completed, 4 - Rejected
  String? statusText; // Make it mutable
  String? imageUrl;
  String? createdByName;
  String? createdByUserProfileImageUrl;

  String? contractReference;
  String? unitNumber;

  int contractId;
  int objectId;

  String? objectName;

  String? translatedRequestTypeText;

  RequestModel({
    this.id,
    required this.ticketNumber,
    this.requestType,
    this.createdAt,
    this.description,
    this.status,
    this.statusText,
    this.imageUrl,
    this.createdByName,
    this.createdByUserProfileImageUrl,
    required this.contractId,
    this.contractReference,
    this.unitNumber,
    this.requestTypeId,
    required this.objectId,
    this.objectName,
  });

  /// Helper methods
  //String get fullName => '$firstName $lastName';

  String formattedDate(BuildContext context) {
    return TFormatter.formatDateShorted(createdAt, context);
  }

  //String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  // Convert JSON response to RequestModel
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id']?.toString() ?? '0', // Convert to String
      ticketNumber: json['ticket_number'] ?? '',
      requestType: json['request_type'] ?? '',
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      description: json['description'] ?? '',
      status: json['status'] ?? 0, // Default to 0 if null
      statusText:
          json['status_text'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to "Unknown"
      imageUrl: json.containsKey('image_url') ? json['image_url'] : null,
      createdByName:
          json['created_by_name'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to "Unknown"
      createdByUserProfileImageUrl: json['created_by_profile_image_url'] ?? '',
      contractId: json['contract_id'] ?? 0, // Default to 0 if null
      contractReference: json['contract_reference'] ?? '',
      unitNumber:
          json['unit_number'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to Unknown if null
      requestTypeId: json['request_type_id'] ?? 0, // Default to 0 if null
      objectId: json['object_id'] ?? 0, // Default to 0 if null
      objectName: json['object_name'] ?? '',
    );
  }

  String get formattedDateTimeWithText =>
      TFormatter.formatDateTimeWithText(createdAt);
  String get formattedDateWithText => TFormatter.formatDateWithText(createdAt);

  String getTranslatedRequestTypeSync() {
    return translatedRequestTypeText ?? requestType ?? '';
  }

  Future<String> translateStatusText() async {
    return await TranslationApi.smartTranslate(statusText.toString());
  }

  Future<String> translateDescriptionText() async {
    return await TranslationApi.smartTranslate(description.toString());
  }

  Future<String> translateRequestType() async {
    if (translatedRequestTypeText != null) return translatedRequestTypeText!;
    translatedRequestTypeText = await TranslationApi.smartTranslate(
      requestType.toString(),
    );
    return translatedRequestTypeText!;
  }

  /// Static function to create an empty request model.
  static RequestModel empty() => RequestModel(
    ticketNumber: 'Maintenance (A1-B1-20250305-3)',
    id: '0',
    createdByUserProfileImageUrl: '',
    createdByName: 'Adilson Paulo Amado Jacinto',
    createdAt: DateTime.parse('2025-03-16 15:30:00'),
    description:
        'This is a sample description blah blah blah, checking the lentgh of the description',
    imageUrl: 'https://via.placeholder.com/150',
    requestType: 'Maintenance',
    status: 1,
    statusText: 'Pending',
    contractId: 0,
    contractReference: 'A1-B1-20250305-3',
    unitNumber: 'A1-B1-20250305-3',
    requestTypeId: 0,
    objectId: 0,
  ); // Default
}
