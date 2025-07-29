class AgentInvitationModel {
  String agencyName;
  String agentEmail;
  String buildingAddress;
  int agentId;
  String agentFirstName;
  String agentLastName;
  String agentPhoneNumber;
  String agentCountryCode;
  int id;

  AgentInvitationModel({
    required this.id,
    required this.agencyName,
    required this.agentEmail,
    required this.buildingAddress,
    required this.agentId,
    required this.agentFirstName,
    required this.agentLastName,
    required this.agentPhoneNumber,
    required this.agentCountryCode,
  });
}
