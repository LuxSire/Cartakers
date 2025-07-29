import 'package:flutter/widgets.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class ContractModel {
  final String? id;
  final int? agencyId;
  int? buildingId;
  String? contractCode;
  int? unitId;
  DateTime? startDate;
  DateTime? endDate;
  int? zoneId;
  int? statusId; // 1 opren, 2 - closed
  final DateTime? createdAt; // Make it mutable
  List<UserModel>? tenants; // tenats
  int? tenantCount;
  String? tenantNames;
  String unitNumber;

  String? buildingName; // building name

  ContractModel({
    this.id,
    this.agencyId,
    this.buildingId,
    this.contractCode,
    this.unitId,
    this.startDate,
    this.endDate,
    this.zoneId,
    this.statusId,
    this.createdAt,
    this.tenants,
    this.tenantCount,
    this.tenantNames,
    this.unitNumber = '',
    this.buildingName,
  });

  // Convert JSON response to UnitModel
  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id']?.toString() ?? '',
      buildingId: json['building_id'] ?? 0,
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
      tenantCount: json['tenant_count'] ?? 0,
      tenantNames: json['tenant_names'] ?? '',
      unitNumber: json['unit_number']?.toString() ?? '',
      buildingName: json['building_name']?.toString() ?? '',
    );
  }

  // Convert JSON response to
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'building_id': buildingId,
      'contract_code': contractCode,
      'unit_id': unitId,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'zone_id': zoneId,
      'status': statusId,
      'created_at': createdAt?.toIso8601String(),
      'tenant_count': tenantCount,
      'tenant_names': tenantNames,
      'unit_number': unitNumber,
      'building_name': buildingName,
    };
  }

  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedStartDate => TFormatter.formatDate(startDate);
  String get formattedEndDate => TFormatter.formatDate(endDate);

  bool get isEmpty => id == null || id!.isEmpty;

  /// Static function to create an empty request model.
  static ContractModel empty() => ContractModel(id: null);
}
