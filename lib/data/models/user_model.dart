
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int isPrimaryTenant;
  final String moveInDate;
  final int unitId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isPrimaryTenant,
    required this.moveInDate,
    required this.unitId,
  });

  // Factory constructor for creating a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      isPrimaryTenant: json['is_primary_tenant'],
      moveInDate: json['move_in_date'],
      unitId: json['unit_id'],
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'is_primary_tenant': isPrimaryTenant,
      'move_in_date': moveInDate,
      'unit_id': unitId,
    };
  }
}
