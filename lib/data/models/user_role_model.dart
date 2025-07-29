class UserRoleModel {
  final int id;
  final String name;
  final int roleId; // main role id
  String? nameTranslated;

  UserRoleModel({required this.id, required this.name, required this.roleId});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      roleId: json['role_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role_id': roleId};
  }
}
