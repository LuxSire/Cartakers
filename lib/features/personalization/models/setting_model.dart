/// Model class representing user data.
class SettingsModel {
  final String? id;

  String appName;
  String appLogo;
  String companyName;
  String selectedObjectId;

  /// Constructor for SettingModel.
  SettingsModel({
    this.id,
    this.appName = '',
    this.appLogo = '',
    this.companyName = '',
    this.selectedObjectId = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'appLogo': appLogo,
      'companyName': companyName,
      'selectedObjectId': selectedObjectId,
    };
  }
}
