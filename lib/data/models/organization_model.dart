import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/utils/formatters/formatter.dart';

class OrganizationModel {
  String? id;
  String? name;
  String? address;
  int? typeId;
  String? type;
  DateTime? createdAt;

  OrganizationModel({
    this.id,
    this.name,
    this.typeId,
    this.type,
    this.createdAt,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);

  /// Static function to create an empty building model.
  static OrganizationModel empty() =>
      OrganizationModel(id: ''); // Default createdAt to current time

  // Convert JSON response to RequestModel
  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] != null ? json['id'].toString() : null,
      name: json['name'] as String?,
      typeId: json['type_id'] != null ? json['type_id'] as int : null,
      type: json['type'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type_id': typeId,
      'type': type,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
