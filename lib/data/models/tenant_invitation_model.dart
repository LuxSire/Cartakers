class TenantInvitationModel {
  String agencyName;
  String tenantEmail;
  String buildingAddress;
  int tenantId;
  String tenantFirstName;
  String tenantLastName;
  String tenantPhoneNumber;
  String tenantCountryCode;

  TenantInvitationModel({
    required this.agencyName,
    required this.tenantEmail,
    required this.buildingAddress,
    required this.tenantId,
    required this.tenantFirstName,
    required this.tenantLastName,
    required this.tenantPhoneNumber,
    required this.tenantCountryCode,
  });
}
