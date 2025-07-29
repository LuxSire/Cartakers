import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class BuildingModel {
  String? id;
  int? agencyId;
  String? name;
  String? street;
  String? zipCode;
  String? buildingNumber;
  String? canton;
  String? address;

  final int? totalUnits;
  final int? totalFloors;
  String? imgUrl;
  final DateTime? createdAt;
  DateTime? updatedAt;
  String? location;
  List<UnitModel>? units;
  final int? totalTenants;
  final int? totalContracts;

  BuildingModel({
    this.id,
    this.agencyId,
    this.name,
    this.street,
    this.zipCode,
    this.buildingNumber,
    this.canton,
    this.address,
    this.totalUnits,
    this.totalFloors,
    this.imgUrl,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.totalTenants,
    this.totalContracts,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);

  /// Static function to create an empty building model.
  static BuildingModel empty() =>
      BuildingModel(id: ''); // Default createdAt to current time

  // Convert JSON response to RequestModel
  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id']?.toString() ?? '',
      agencyId: json['agency_id'] ?? 0,
      name: json['name'] ?? '',
      imgUrl: json['img_url'] ?? '',
      street: json['street'] ?? '',
      zipCode: json['zip_code'] ?? '',
      buildingNumber: json['building_number'] ?? '',
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
      totalTenants: json['total_tenants'] ?? 0,
      totalContracts: json['total_contracts'] ?? 0,
    );
  }

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_id': agencyId,
      'name': name,
      'img_url': imgUrl,
      'street': street,
      'zip_code': zipCode,
      'building_number': buildingNumber,
      'canton': canton,
      'address': address,
      'total_units': totalUnits,
      'total_floors': totalFloors,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'location': location,
      'total_tenants': totalTenants,
      'total_contracts': totalContracts,
    };
  }
}
