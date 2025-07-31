import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class ObjectModel {
  String? id;
  int? companyId;
  String? name;
  String? street;
  String? zipCode;
  String? objectNumber;
  String? canton;
  String? address;

  final int? totalUnits;
  final int? totalFloors;
  String? imgUrl;
  final DateTime? createdAt;
  DateTime? updatedAt;
  String? location;
  List<UnitModel>? units;
  final int? totalUsers;
  final int? totalContracts;

  ObjectModel({
    this.id,
    this.companyId,
    this.name,
    this.street,
    this.zipCode,
    this.objectNumber,
    this.canton,
    this.address,
    this.totalUnits,
    this.totalFloors,
    this.imgUrl,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.totalUsers,
    this.totalContracts,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);

  /// Static function to create an empty building model.
  static ObjectModel empty() =>
      ObjectModel(id: ''); // Default createdAt to current time

  // Convert JSON response to RequestModel
  factory ObjectModel.fromJson(Map<String, dynamic> json) {
    return ObjectModel(
      id: json['id']?.toString() ?? '',
      companyId: json['company_id'] ?? 0,
      name: json['name'] ?? '',
      imgUrl: json['img_url'] ?? '',
      street: json['street'] ?? '',
      zipCode: json['zip_code'] ?? '',
      canton: json['canton'] ?? '',
      address: json['address'] ?? '',
      totalUnits: json['total_units'] ?? 0,
      totalFloors: json['total_floors'] ?? 0,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),

      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      location: json['location'] ?? '',
      totalUsers: json['total_users'] ?? 0,
      totalContracts: json['total_contracts'] ?? 0,
    );
  }

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'img_url': imgUrl,
      'street': street,
      'zip_code': zipCode,
      'object_number': objectNumber,
      'canton': canton,
      'address': address,
      'total_units': totalUnits,
      'total_floors': totalFloors,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'location': location,
      'total_users': totalUsers,
      'total_contracts': totalContracts,
    };
  }
}
