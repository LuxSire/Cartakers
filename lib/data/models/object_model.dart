import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class ObjectModel {
  String? id;
  int? companyId;
  String? name;
  String? street;
  String? zipCode;
  String? objectNumber;
  String? state;
  String? address;
  String? occupancy;
  String? zoning;
  String? city;
  String? description;
  String? currency;
  int? owner;
  int? status;
  String? type_;
  double? price;
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
    this.state,
    this.occupancy,
    this.zoning,
    this.city,
    this.description,
    this.currency,
    this.owner,
    this.status,
    this.type_,
    this.price,
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
      companyId: json['company'] ?? 0,
      occupancy: json['occupancy'] ?? 0,
      zoning: json['zoning'] ?? '',
      city: json['city'] ?? '',
      description: json['description'] ?? '',
      owner: json['owner'] ?? '',
      status: json['status'] ?? '',
      type_: json['type'] ?? '',
      price: json['price'] ?? '',
      currency: json['currency'] ?? '',
      name: json['name'] ?? '',
      imgUrl: json['img_url'] ?? '',
      street: json['street'] ?? '',
      zipCode: json['zip_code'] ?? '',
      state: json['state'] ?? '',
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
      'sate': state,
      'address': address,
      'total_units': totalUnits,
      'total_floors': totalFloors,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'location': location,
      'total_users': totalUsers,
      'total_contracts': totalContracts,
      'occupancy': occupancy,
      'zoning': zoning,
      'city': city,
      'description': description,
      'currency': currency,
      'owner': owner,
      'status': status,
      'type': type_,
      'price': price,
    };
  }
}
