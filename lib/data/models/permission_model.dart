import 'package:flutter/widgets.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class PermissionModel {
  final String? id;
  final int? companyId;
  int? objectId;
  int? permissionId ;
  int? userId;
  String? userName;
  DateTime? startDate;
  DateTime? endDate;
  List<UserModel>? users;
  String? objectName; // object name

  PermissionModel({
    this.id,
    this.companyId,
    this.objectId,
    this.permissionId,
    this.userId,
    this.startDate,
    this.endDate,
    this.objectName,
    this.userName,
    this.users,
  });

  // Convert JSON response to UnitModel
  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id']?.toString() ?? '',
      objectId: json['object_id'] ?? 0,
      permissionId: json['permission_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name']?.toString() ?? '',
      objectName: json['object_name']?.toString() ?? '',
      startDate:
          json['start_date'] != null
              ? DateTime.parse(json['start_date']).toLocal()
              : null,
      endDate:
          json['end_date'] != null
              ? DateTime.parse(json['end_date']).toLocal()
              : null,

    );
  }

  // Convert JSON response to
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object_id': objectId,
      'permission_id': permissionId,
      'user_id': userId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'object_name': objectName,
    };
  }

  String get formattedStartDate => TFormatter.formatDate(startDate);
  String get formattedEndDate => TFormatter.formatDate(endDate);

  bool get isEmpty => id == null || id!.isEmpty;

  /// Static function to create an empty request model.
  static PermissionModel empty() => PermissionModel(id: null);
}
