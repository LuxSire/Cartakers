class CompanyInvitationModel {
  String companyName;
  String email;
  int companyId;
  String address;
  String  FirstName;
  String LastName;
  String PhoneNumber;
  String Country;
  int id;

  CompanyInvitationModel({
    required this.id,
    required this.companyName,
    required this.email,
    required this.address,
    required this.companyId,
    required this.FirstName,
    required this.LastName,
    required this.PhoneNumber,
    required this.Country,
  });
}
