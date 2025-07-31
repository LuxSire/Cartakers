/// Model class representing user data.
class SettingsModel {
  final String? id;

  String appName;
  String appLogo;
  String agencyName;
  String selectedObjectId;

  /// Constructor for SettingModel.
  SettingsModel({
    this.id,
    this.appName = '',
    this.appLogo = '',
    this.agencyName = '',
    this.selectedObjectId = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'appLogo': appLogo,
      'agencyName': agencyName,
      'selectedObjectId': selectedObjectId,
    };
  }
}
