import 'package:xm_frontend/data/api/translation_api.dart';

import '../../../../utils/formatters/formatter.dart';

/// Model class representing user data.
class UserModel {
  String? id;
  String firstName;
  String lastName;
  String displayName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;
  String roleId;
  String roleName;
  String lang;
  String agencyId;
  String agencyName;
  int? isPrimaryTenant;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fullPhoneNumber;
  String? contractReference;
  int? tenantContractId;
  int? buildingId; // tenant assigned building id
  String? unitNumber; // tenant assigned unit number
  int? contractStatus;
  int? zoneId; // zone id for the tenant which comes from the contract unit

  String? roleNameExt;
  String? status; // status of user, invited, active, disabled
  String? buildingPermissions; // building permission for the user
  String? buildingName;
  int?
  statusId; // status id of the user, 1 for active, 2 for disabled, 3 for invited
  int?
  roleExtId; // role id for the user, 1 for admin, 2 for tenant, 3 for agent

  int? isPushNotificationsEnabled;
  int? isEmailNotificationsEnabled;

  String? translatedStatus;
  String? translatedRoleNameExt;

  List<int>? buildingPermissionIds;

  /// Constructor for UserModel.
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.displayName = '',
    this.roleId = '',
    this.roleName = '',
    this.lang = '',
    this.agencyId = '',
    this.agencyName = '',
    this.createdAt,
    this.updatedAt,
    this.isPrimaryTenant,
    this.fullPhoneNumber,
    this.contractReference,
    this.tenantContractId,
    this.buildingId,
    this.unitNumber,

    this.contractStatus,
    this.buildingName,
    this.zoneId,
    this.isPushNotificationsEnabled,
    this.isEmailNotificationsEnabled,
    this.buildingPermissions,
    this.roleNameExt,
    this.status,
    this.statusId,
    this.roleExtId,
    this.buildingPermissionIds,
  });

  /// Helper methods
  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(email: '', id: ''); // Default

  // Convert UserModel to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'user_name': userName,
      'phone_number': phoneNumber,
      'profile_pic': profilePicture,
      'role_id': roleId,
      'role_name': roleName,
      'lang': lang,
      'agency_id': agencyId,
      'agency_name': agencyName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_primary_tenant': isPrimaryTenant,
      'full_phone_number': fullPhoneNumber,
      'contract_reference': contractReference,
      'tenant_contract_id': tenantContractId,
      'building_id': buildingId,
      'unit_number': unitNumber,
      'contract_status': contractStatus,
      'building_name': buildingName,
      'zone_id': zoneId,
      'is_push_notifications_enabled': isPushNotificationsEnabled,
      'is_email_notifications_enabled': isEmailNotificationsEnabled,
      'role_name_ext': roleNameExt,
      'status': status,
      'building_permissions': buildingPermissions,
      'status_id': statusId,
      'role_ext_id': roleExtId,
      'building_permission_ids': buildingPermissionIds ?? [],
    };
  }

  // Convert JSON back to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      displayName: json['display_name'] ?? '',
      userName: json['user_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profilePicture: json['profile_pic'] ?? '',
      roleId: json['role_id']?.toString() ?? '',
      roleName: json['role_name'] ?? '',
      lang: json['lang'] ?? '',
      agencyId: json['agency_id']?.toString() ?? '',
      agencyName: json['agency_name'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at']).toLocal()
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at']).toLocal()
              : null,
      isPrimaryTenant: json['is_primary_tenant'] ?? 0,
      fullPhoneNumber: json['full_phone_number'] ?? '',
      contractReference: json['contract_reference'] ?? '',
      tenantContractId: json['tenant_contract_id'] ?? 0,
      buildingId: json['building_id'] ?? 0,
      unitNumber: json['unit_number'] ?? '',
      contractStatus: json['contract_status'] ?? 0,
      buildingName: json['building_name'] ?? '',
      zoneId: json['zone_id'] ?? 0,
      isPushNotificationsEnabled: json['is_push_notifications_enabled'] ?? 0,
      isEmailNotificationsEnabled: json['is_email_notifications_enabled'] ?? 0,
      roleNameExt: json['role_name_ext'] ?? '',
      status: json['status'] ?? '',
      buildingPermissions: json['building_permissions'] ?? '',
      statusId: json['status_id'] ?? 0,
      roleExtId: json['role_ext_id'] ?? 0,
      buildingPermissionIds:
          json['building_permission_ids'] != null
              ? (json['building_permission_ids'] is String
                  ? (json['building_permission_ids'] as String)
                      .split(',')
                      .where((e) => e.trim().isNotEmpty)
                      .map((e) => int.tryParse(e.trim()) ?? 0)
                      .where((id) => id != 0)
                      .toList()
                  : (json['building_permission_ids'] as List)
                      .map((e) => int.tryParse(e.toString()) ?? 0)
                      .where((id) => id != 0)
                      .toList())
              : [],
    );
  }

  Future<String> translateStatusText() async {
    return await TranslationApi.smartTranslate(status ?? '');
  }

  Future<String> translateRoleNameExt() async {
    return await TranslationApi.smartTranslate(roleNameExt ?? '');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
