import 'dart:convert';

class AmenityZoneModel {
  final int id;
  final int buildingId;
  final String name;

  DateTime? createdAt;
  DateTime? updatedAt;

  AmenityZoneModel({
    required this.id,
    required this.buildingId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method to create an object from JSON
  factory AmenityZoneModel.fromJson(Map<String, dynamic> json) {
    return AmenityZoneModel(
      id: json['id'],
      buildingId: json['building_id'],
      name: json['name'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
    );
  }

  // Convert object to JSON (useful for sending data to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'building_id': buildingId,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Debugging helper
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
