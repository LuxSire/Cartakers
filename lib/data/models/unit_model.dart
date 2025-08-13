import 'package:flutter/widgets.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class UnitModel {
  final String? id;
  final int? objectId;
  final String? unitNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? description; // Added description field
  String? floorNumber;
  int? statusId; // 1 - vacant, 2 -  occupied
  String? statusText; // Make it mutable
  String? pieceId;
  String? pieceName;
  int? userCount;
  String? contractCode;
  int? currentContractId;
  String? userNames;

  String? objectName; // building name

  List<PermissionModel>? contracts; // tenats

  UnitModel({
    this.id,
    this.objectId,
    this.unitNumber,
    this.createdAt,
    this.floorNumber,
    this.statusId,
    this.statusText,
    this.pieceId,
    this.pieceName,
    this.updatedAt,
    this.userCount,
    this.contractCode,
    this.currentContractId,
    this.userNames,
    this.objectName ,
    this.description,
  });

  // Convert JSON response to UnitModel
  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id']?.toString() ?? '',
      objectId: json['object_id'] ?? 0,
      unitNumber: json['unit_number']?.toString() ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      floorNumber: json['floor_number']?.toString() ?? '',
      statusId: json['status_id'] ?? 0,
      statusText: json['status_text'] ?? '',
      pieceId: json['piece_id']?.toString() ?? '',
      pieceName: json['piece_name'] ?? '',
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
      userCount: json['user_count'] ?? 0,
      contractCode: json['contract_code'] ?? '',
      currentContractId: json['current_contract_id'] ?? 0,
      userNames: json['user_names'] ?? '',
      objectName: json['object_name'] ?? '',
      description: json['description'] ?? '', // Added description parsing
    );
  }

  // create toJson function
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object_id': objectId,
      'unit_number': unitNumber,
      'created_at': createdAt?.toIso8601String(),
      'floor_number': floorNumber,
      'status_id': statusId,
      'status_text': statusText,
      'piece_id': pieceId,
      'piece_name': pieceName,
      'updated_at': updatedAt?.toIso8601String(),
      'user_count': userCount,
      'contract_code': contractCode,
      'current_contract_id': currentContractId,
      'user_names': userNames,
      'object_name': objectName,
      'description' : description, // Added description to JSON
    };
  }

  String get formattedDate => TFormatter.formatDate(updatedAt);

  /// Static function to create an empty request model.
  static UnitModel empty() => UnitModel(
    // unitNumber: 'B1-101',
    id: '',
    // updatedAt: DateTime.parse('2025-01-01 00:00:00'),
    // floorNumber: '7',
    // statusId: 1,
    // statusText: 'Vacant',
    // pieceId: '1',
    // pieceName: '3.5',
  );
}
