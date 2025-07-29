class UnitZoneAssignmentModel {
  final int unitId;
  final String? unitNumber;
  final int? zoneId;
  final String? zoneName;

  UnitZoneAssignmentModel({
    required this.unitId,
    this.unitNumber,
    this.zoneId,
    this.zoneName,
  });

  factory UnitZoneAssignmentModel.fromJson(Map<String, dynamic> json) {
    return UnitZoneAssignmentModel(
      unitId: json['unit_id'] as int,
      unitNumber: json['unit_number'] as String?,
      zoneId: json['zone_id'] != null ? json['zone_id'] as int : null,
      zoneName: json['zone_name'] as String?,
    );
  }
}
