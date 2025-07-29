import 'dart:convert';

class AmenityUnitModel {
  final int id;
  final int buildingAmenityId;
  final String name;
  final int status;
  final bool requiresBooking;
  DateTime? bookingDate;
  String? bookingStartTime;
  String? bookingEndTime;
  bool isBookingUpdate;
  int bookingId;

  AmenityUnitModel({
    required this.id,
    required this.buildingAmenityId,
    required this.name,
    required this.status,
    required this.requiresBooking,
    this.bookingDate,
    this.bookingStartTime,
    this.bookingEndTime,
    this.isBookingUpdate = false,
    this.bookingId = 0,
  });

  // Factory method to create an object from JSON
  factory AmenityUnitModel.fromJson(Map<String, dynamic> json) {
    return AmenityUnitModel(
      id: json['id'],
      buildingAmenityId: json['building_amenity_id'],
      name: json['unit_name'],
      status: json['status'],
      requiresBooking:
          json['requires_booking'] == 1, // Assuming API returns 1/0 for boolean
    );
  }

  // Convert object to JSON (useful for sending data to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'building_amenity_id': buildingAmenityId,
      'unit_name': name,
      'status': status,
      'requires_booking': requiresBooking ? 1 : 0, // Convert boolean to 1/0
    };
  }

  // Debugging helper
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
