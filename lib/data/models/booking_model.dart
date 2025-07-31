import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class BookingModel {
  final String? id;
  final DateTime? date;

  final String? startTime;
  final String? endTime;
  String? time;
  int? status;
  String? statusText; // Make it mutable
  String? title;
  DateTime? createdAt;
  int? amenityUnitId;
  String? createdByName;
  String createdByUserProfileImageUrl;
  String? objectName;
  int? objectId;
  String? categoryName;
  int? categoryId;

  BookingModel({
    this.id,
    this.date,
    this.time,
    this.status,
    this.statusText,
    this.title,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.amenityUnitId,
    this.createdByName,
    this.createdByUserProfileImageUrl = '',
    this.objectName,
    this.objectId,
    this.categoryName,
    this.categoryId,
  });

  // Convert JSON response to RequestModel
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '0', // Convert to String
      date:
          json['date'] != null
              ? DateTime.parse(json['date'])
                  .toLocal() // Convert to local time
              : DateTime.now(), // Default to now() if null
      time: json['time'] ?? "", // Default to empty string
      status: json['status_id'] ?? 0, // Default to 0 if null
      statusText:
          json['status_text'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to "Unknown"
      title: json['title'] ?? "Unknown", // Default to "No Title"
      startTime: json['start_time'] ?? "00:00", // Default to "00:00"
      endTime: json['end_time'] ?? "00:00", // Default to "00:00"
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
                  .toLocal() // Convert to local time
              : DateTime.now(), // Default to now() if null
      amenityUnitId: json['amenity_unit_id'] ?? 0, // Default to 0 if null
      createdByName:
          json['created_by_name'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to "Unknown"
      createdByUserProfileImageUrl:
          json['created_by_profile_image_url'] ?? '', // Default to "Unknown"
      objectName:
          json['object_name'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to "Unknown"
      objectId:
          json['object_id'] != null
              ? int.tryParse(json['object_id'].toString()) ?? 0
              : 0, // Default to 0 if null or invalid

      categoryName:
          json['category_name'] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'), // Default to "Unknown"
      categoryId:
          json['category_id'] != null
              ? int.tryParse(json['category_id'].toString()) ?? 0
              : 0, // Default to 0 if null or invalid
    );
  }

  String get formattedDateTimeWithText =>
      TFormatter.formatDateTimeWithText(date);
  String get formattedDateWithText => TFormatter.formatDateWithText(date);

  Future<String> translateStatusText() async {
    return await TranslationApi.smartTranslate(statusText.toString());
  }

  Future<String> translateBookingTitle() async {
    return await TranslationApi.smartTranslate(title.toString());
  }

  static BookingModel empty() => BookingModel(id: ''); // Default
}
