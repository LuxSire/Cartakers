import 'package:cartakers/data/models/unit_model.dart';
import 'package:cartakers/utils/formatters/formatter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ObjectModel {
  int? id;
  int? companyId;
  String? name;
  String? street;
  String? zipCode;
  String? country;
  String? state;
  String? address;
  String? occupancy;
  String? zoning;
  String? city;
  String? description;
  String? currency;
  int? owner;
  String? status;
  String? type_;
  double? price;
  double? noi;
  double? caprate;
  double? yieldGross;
  double? yieldNet;
  int? totalUnits;
  int? totalFloors;
  String? imgUrl;
  final DateTime? createdAt;
  DateTime? updatedAt;
  String? location;
  List<UnitModel>? units;
  final int? totalUsers;
  final int? totalContracts;
  int? sqm;
  double? longitude;
  double? latitude;

  ObjectModel({
    this.id,
    this.companyId,
    this.name,
    this.street,
    this.zipCode, 
    this.state,
    this.country  ,
    this.occupancy,
    this.zoning,
    this.city,
    this.description,
    this.currency,
    this.owner,
    this.status,
    this.type_,
    this.price,
    this.yieldGross,
    this.noi,
    this.caprate,
    this.yieldNet,
    this.address,
    this.totalUnits,
    this.totalFloors,
    this.imgUrl,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.totalUsers,
    this.totalContracts,
    this.sqm, 
    this.longitude,
    this.latitude
  });

  final APIkey = dotenv.env['GOOGLE_MAP'] ?? '';
  Future<void> getCoordinatesFromAddress() async
  {

    // Use the geocoding package to convert the address to coordinates
    try {
      String my_address = [
          street,
          zipCode,
          city,
          state,
        country,
      ].where((part) => part != null && part.isNotEmpty).join(' ');

      final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(my_address)}&key=$APIkey',
      );
      final response = await http.get(url);
      final data = json.decode(response.body);
      debugPrint('URL used: $url');
      debugPrint('Response data: $data'); 
      debugPrint('Let s see the coordinates of : $my_address');

      if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          latitude = location['lat'];
          longitude = location['lng'];
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
  }


  String get formattedDate => TFormatter.formatDate(createdAt);

  /// Static function to create an empty building model.
  static ObjectModel empty() =>
      ObjectModel(id: 1); // Default createdAt to current time

  // Convert JSON response to RequestModel
  factory ObjectModel.fromJson(Map<String, dynamic> json) {
    return ObjectModel(
      id: json['id'] ?? 0,
      companyId: json['company'] ?? 0,
      occupancy: json['occupancy'] ?? 0,
      zoning: json['zoning'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      owner: json['owner'] ?? 1,
      status: json['status'] ?? 'Started',
      type_: json['type_'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      currency: json['currency'] ?? '',
      name: json['name'] ?? '',
      imgUrl: json['img_url'] ?? '',
      street: json['street'] ?? '',
      zipCode: json['zip_code'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      totalUnits: json['units'] ?? 0,
      totalFloors: json['Floors'] ?? 0,
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
      yieldGross: json['yield_gross'] ?? 0.0,
      yieldNet: json['yield_net'] ?? 0.0,
      noi: json['noi'] != null ? double.tryParse(json['noi'].toString()) : 0.0,
      caprate: json['caprate'] != null ? double.tryParse(json['caprate'].toString()) : 0.0,
      sqm: json['sqm'] ?? 0,
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
      'state': state,
      'country': country,
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
      'yield_gross': yieldGross,
      'yield_net': yieldNet,
      'noi': noi,
      'caprate': caprate,
      'sqm': sqm,
    };
  }
}
