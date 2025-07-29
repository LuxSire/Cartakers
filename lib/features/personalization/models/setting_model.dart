/// Model class representing user data.
class SettingsModel {
  final String? id;

  String appName;
  String appLogo;
  String agencyName;
  String selectedBuildingId;

  /// Constructor for SettingModel.
  SettingsModel({
    this.id,

    this.appName = '',
    this.appLogo = '',
    this.agencyName = '',
    this.selectedBuildingId = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'appLogo': appLogo,
      'agencyName': agencyName,
      'selectedBuildingId': selectedBuildingId,
    };
  }
}
