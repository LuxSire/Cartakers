import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';

class RequestLog {
  final int id;
  final int status;
  final String statusText;
  final String description;
  final DateTime createdAt;
  final String processedBy;
  final String adminViewProcessedBy;

  RequestLog({
    required this.id,
    required this.status,
    required this.statusText,
    required this.description,
    required this.createdAt,
    required this.processedBy,
    required this.adminViewProcessedBy,
  });

  factory RequestLog.fromJson(Map<String, dynamic> json) {
    return RequestLog(
      id: json["id"] ?? 0,
      status: json["status"] ?? 0,
      statusText:
          json["status_text"] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'),
      description: json["description"] ?? "",
      createdAt:
          DateTime.parse(json["created_at"]).toLocal(), // Convert to DateTime
      processedBy:
          json["processed_by"] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'),
      adminViewProcessedBy:
          json["admin_view_processed_by"] ??
          AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_unknown'),
    );
  }
}
