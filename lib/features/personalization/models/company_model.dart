import 'package:xm_frontend/data/api/translation_api.dart';

import '../../../../utils/formatters/formatter.dart';

/// Model class representing user data.
class CompanyModel {
  int? id;
  String name;
  String displayName;
  String userName;
  String email;
  String phone;
  String profilePicture;
  int roleId;
  String countryCode; // Added country code
  String country;
  String roleName;
  String lang;
  int companyId;
  String companyName;
  int? isPrimaryUser;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fullPhoneNumber;
  String? contractReference;
  int? userContractId;
  int? objectId; // user assigned object id
  String? unitNumber; // tenant assigned unit number
  int? contractStatus;
  int? zoneId; // zone id for the tenant which comes from the contract unit
  String? token; // Text representation of contract status
  String? city;
  String? roleNameExt;
  String? status; // status of user, invited, active, disabled
  List<Map<String, dynamic>> objectPermissions = const []; // object permission for the user
  String? objectName;
  int?
  statusId; // status id of the user, 1 for active, 2 for disabled, 3 for invited
  int?
  roleExtId; // role id for the user, 1 for admin, 2 for tenant, 3 for agent

  int? isPushNotificationsEnabled;
  int? isEmailNotificationsEnabled;

  String? translatedStatus;
  String? translatedRoleNameExt;

  List<int>? objectPermissionIds;

  /// Constructor for UserModel.
  CompanyModel({
    this.id,
    this.token = '',  
    required this.email,
    this.name = '',
    this.userName = '',
    this.phone = '',
    this.profilePicture = '',
    this.displayName = '',
    this.roleId = 1,
    this.roleName = '',
    this.lang = '',
    this.companyId = 1,
    this.companyName = '',
    this.createdAt,
    this.updatedAt,
    this.isPrimaryUser,
    this.fullPhoneNumber,
    this.contractReference,
    this.userContractId,
    this.objectId,
    this.unitNumber,
    this.countryCode='', 
    this.contractStatus,
    this.objectName,
    this.zoneId,
    this.isPushNotificationsEnabled,
    this.isEmailNotificationsEnabled,
    this.objectPermissions = const [],
    this.roleNameExt,
    this.status,
    this.statusId,
    this.roleExtId,
    this.objectPermissionIds,
    this.city,
    this.country=''
  });

  /// Helper methods
  String get fullName => '$name';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phone);

  String get formattedDate => TFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  /// Static function to create an empty company model.
  static CompanyModel empty() => CompanyModel(email: '', id: 0); // Default

  // Convert UserModel to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'city': city,
      'country': country, // Added country code'
      'display_name': displayName,
      'user_name': userName,
      'phone_number': phone,
      'profile_pic': profilePicture,
      'role_id': roleId,
      'country': country, // Added country code  
      'role_name': roleName,
      'lang': lang,
      'company_id': companyId,
      'company_name': companyName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_primary_user': isPrimaryUser,
      'full_phone_number': fullPhoneNumber,
      'contract_reference': contractReference,
      'user_contract_id': userContractId,
      'object_id': objectId,
      'unit_number': unitNumber,
      'contract_status': contractStatus,
      'object_name': objectName,
      'zone_id': zoneId,
      'is_push_notifications_enabled': isPushNotificationsEnabled,
      'is_email_notifications_enabled': isEmailNotificationsEnabled,
      'role_name_ext': roleNameExt,
      'status': status,
      'objectpermissions': objectPermissions,
      'status_id': statusId,
      'role_ext_id': roleExtId,
      'object_permission_ids': objectPermissionIds ?? [],
    };
  }

  // Convert JSON back to UserModel
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      displayName: json['display_name'] ?? '',
      userName: json['user_name'] ?? '',
      phone: json['phone']?.toString() ?? '',
      profilePicture: json['profile_pic'] ?? '',
      roleId: json['role_id']?.toInt() ?? 0,
      roleName: json['role_name'] ?? '',
      lang: json['lang'] ?? '',
      companyId: (json['company_id'] ?? json['company']) ?? 0,  // handle both 'company' and 'company_id' fields
      companyName: json['company_name'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at']).toLocal()
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at']).toLocal()
              : null,
      isPrimaryUser: int.tryParse(json['is_primary_user']?.toString() ?? '0') ?? 0,
      fullPhoneNumber: json['full_phone_number']?.toString() ?? '',
      contractReference: json['contract_reference']?.toString() ?? '',
      userContractId: int.tryParse(json['user_contract_id']?.toString() ?? '0') ?? 0,
      objectId: int.tryParse(json['object_id']?.toString() ?? '0') ?? 0,
      unitNumber: json['unit_number']?.toString() ?? '',
      contractStatus: int.tryParse(json['contract_status']?.toString() ?? '0') ?? 0,
      objectName: json['object_name']?.toString() ?? '',
      zoneId: int.tryParse(json['zone_id']?.toString() ?? '0') ?? 0,
      isPushNotificationsEnabled: int.tryParse(json['is_push_notifications_enabled']?.toString() ?? '0') ?? 0,
      isEmailNotificationsEnabled: int.tryParse(json['is_email_notifications_enabled']?.toString() ?? '0') ?? 0,
      roleNameExt: json['role_name_ext']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      objectPermissions: (json['objectpermissions'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      statusId: int.tryParse(json['status_id']?.toString() ?? '0') ?? 0,
      roleExtId: int.tryParse(json['role_ext_id']?.toString() ?? '0') ?? 0,
      objectPermissionIds:
          json['object_permission_ids'] != null
              ? (json['object_permission_ids'] is String
                  ? (json['object_permission_ids'] as String)
                      .split(',')
                      .map((e) => int.tryParse(e.trim()))
                      .whereType<int>()
                      .toList()
                  : (json['object_permission_ids'] as List)
                      .map((e) => int.tryParse(e.toString()))
                      .whereType<int>()
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
      other is CompanyModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
