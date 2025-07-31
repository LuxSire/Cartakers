import 'package:flutter/widgets.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class ContractModel {
  final String? id;
  final int? companyId;
  int? objectId;
  String? contractCode;
  int? unitId;
  DateTime? startDate;
  DateTime? endDate;
  int? zoneId;
  int? statusId; // 1 opren, 2 - closed
  final DateTime? createdAt; // Make it mutable
  List<UserModel>? users; // tenats
  int? userCount;
  String? userNames;
  String unitNumber;

  String? objectName; // object name

  ContractModel({
    this.id,
    this.companyId,
    this.objectId,
    this.contractCode,
    this.unitId,
    this.startDate,
    this.endDate,
    this.zoneId,
    this.statusId,
    this.createdAt,
    this.users,
    this.userCount,
    this.userNames,
    this.unitNumber = '',
    this.objectName,
  });

  // Convert JSON response to UnitModel
  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id']?.toString() ?? '',
      objectId: json['object_id'] ?? 0,
      contractCode: json['contract_code']?.toString() ?? '',
      unitId: json['unit_id'] ?? 0,
      startDate:
          json['start_date'] != null
              ? DateTime.parse(json['start_date']).toLocal()
              : null,
      endDate:
          json['end_date'] != null
              ? DateTime.parse(json['end_date']).toLocal()
              : null,
      zoneId: json['zone_id'] ?? 0,
      statusId: json['status'] ?? 0,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at']).toLocal()
              : DateTime.now(),
      userCount: json['user_count'] ?? 0,
      userNames: json['user_names'] ?? '',
      unitNumber: json['unit_number']?.toString() ?? '',
      objectName: json['object_name']?.toString() ?? '',
    );
  }

  // Convert JSON response to
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object_id': objectId,
      'contract_code': contractCode,
      'unit_id': unitId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'zone_id': zoneId,
      'status': statusId,
      'created_at': createdAt?.toIso8601String(),
      'user_count': userCount,
      'user_names': userNames,
      'unit_number': unitNumber,
      'object_name': objectName,
    };
  }

  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedStartDate => TFormatter.formatDate(startDate);
  String get formattedEndDate => TFormatter.formatDate(endDate);

  bool get isEmpty => id == null || id!.isEmpty;

  /// Static function to create an empty request model.
  static ContractModel empty() => ContractModel(id: null);
}
