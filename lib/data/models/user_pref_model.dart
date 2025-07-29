class UserPrefModel {
  final String id;
  final String displayName;
  final bool hasLoggedIn;
  final bool hasRegistered;
  final String? profilePic;

  final int? agencyId;
  final int roleId;
  final String roleName;
  final String email;
  final bool isAutoLogin;

  final bool isNotificationsEnabled;
  final bool isBookingRemindersEnabled;

  final bool isPushNotificationsEnabled;
  final bool isEmailNotificationsEnabled;

  UserPrefModel({
    required this.id,
    required this.displayName,
    required this.hasLoggedIn,
    required this.hasRegistered,
    required this.isAutoLogin,

    required this.agencyId,
    this.profilePic,

    this.isNotificationsEnabled = true, // Default: ON
    this.isBookingRemindersEnabled = true, // Default: ON
    required this.roleId,
    required this.roleName,
    required this.email,
    this.isPushNotificationsEnabled = true, // Default: ON
    this.isEmailNotificationsEnabled = true, // Default: ON
  });

  // Convert UserModel to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'has_logged_in': hasLoggedIn,
      'has_registered': hasRegistered,
      'is_auto_login': isAutoLogin,

      'agency_id': agencyId,
      'profile_pic': profilePic,

      'is_notifications_enabled': isNotificationsEnabled,
      'is_booking_reminders_enabled': isBookingRemindersEnabled,
      'role_id': roleId,
      'role_name': roleName,
      'email': email,
      'is_push_notifications_enabled': isPushNotificationsEnabled,
      'is_email_notifications_enabled': isEmailNotificationsEnabled,
    };
  }

  // Convert JSON back to UserModel
  factory UserPrefModel.fromJson(Map<String, dynamic> json) {
    return UserPrefModel(
      id: json['id'] ?? '',
      displayName: json['display_name'] ?? '',
      hasLoggedIn: json['has_logged_in'] ?? false,
      hasRegistered: json['has_registered'] ?? false,
      isAutoLogin: json['is_auto_login'] ?? false,

      agencyId: json['agency_id'] ?? 0,
      profilePic: json['profile_pic'] ?? '',

      isNotificationsEnabled: json['is_notifications_enabled'] ?? true,
      isBookingRemindersEnabled: json['is_booking_reminders_enabled'] ?? true,
      roleId: json['role_id'] ?? 0,
      roleName: json['role_name'] ?? '',
      email: json['email'] ?? '',

      isPushNotificationsEnabled: json['is_push_notifications_enabled'] ?? true,
      isEmailNotificationsEnabled:
          json['is_email_notifications_enabled'] ?? true,
    );
  }
}
