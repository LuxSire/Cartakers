import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/repositories/settings/settings_repository.dart';
import 'package:xm_frontend/features/personalization/models/setting_model.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../media/models/image_model.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  // Observable variables
  RxBool loading = false.obs;
  Rx<SettingsModel> settings = SettingsModel().obs;

  final formKey = GlobalKey<FormState>();
  final appNameController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final freeShippingThresholdController = TextEditingController();

  // Dependencies
  final settingRepository = Get.put(SettingsRepository());

  @override
  void onInit() {
    // Fetch setting details on controller initialization
    fetchSettingDetails();
    super.onInit();
  }

  /// Fetches setting details from the repository
  Future<SettingsModel> fetchSettingDetails() async {
    try {
      loading.value = true;
      final settings = await settingRepository.getSettings();
      this.settings.value = settings;

      debugPrint('Settings: ${settings.toJson()}');

      appNameController.text = settings.appName;

      loading.value = false;

      return settings;
    } catch (e) {
       debugPrint('Error fetching company details: $e');
      // TLoaders.errorSnackBar( title: 'Something went wrong.',message: e.toString(),
       
      return SettingsModel();
    }
  }

  void updateSettingInformation() async {
    try {
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      settings.value.appName = appNameController.text.trim();

      await settingRepository.updateSettingDetails(settings.value);
      settings.refresh();

      loading.value = false;
      TLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'App Settings has been updated.',
      );
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
