import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/models/company_invitation_model.dart';
import 'package:cartakers/data/repositories/user/user_repository.dart';
import 'package:cartakers/routes/routes.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/text_strings.dart';
import '../../personalization/controllers/user_controller.dart';
import '../../personalization/models/user_model.dart';

/// Controller for handling login functionality
class InvitationController extends GetxController {
  static InvitationController get instance => Get.find();

  /// Local storage instance for remembering email and password
  final localStorage = GetStorage();

  /// Text editing controller for the email field
  final invitation = TextEditingController();

  /// Form key for the login form
  final invitationFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    // email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    // password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> validateCode() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        AppLocalization.of(
          Get.context!,
        ).translate('invitation_screen.lbl_validating_your_code'),
        TImages.buildingsIllustration,
      );

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!invitationFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Login user using Email & Password Authentication
      final userDetails = await AuthenticationRepository.instance
          .validateInvitationCode(invitation.text.trim());

      // Remove Loader
      TFullScreenLoader.stopLoading();

      if (userDetails.isNotEmpty) {
        // Store User Details
        debugPrint('Userdetails: : $userDetails');

        Get.toNamed(
          Routes.registerAdmin,
          arguments: CompanyInvitationModel(
            id: userDetails['id'] ?? 0,
            companyName: userDetails['company_name'],
            email: userDetails['email'],
            companyId: userDetails['company_id'],
            FirstName: userDetails['first_name'] ?? '',
            LastName: userDetails['last_name'] ?? '',
            PhoneNumber: userDetails['phone'] ?? '',
            Country: userDetails['country'] ?? '',
            address: userDetails['address'] ?? '',
          ),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('invitation_screen.err_msg_dialog_title_failed_token'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('invitation_screen.err_msg_dialog_content_failed_token'),
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<UserModel> fetchUserInformation() async {
    // Fetch user details and assign to UserController
    final controller = UserController.instance;
    UserModel user;
    if (controller.user.value.id == null || controller.user.value.id!.isEmpty) {
      user = await UserController.instance.fetchUserDetails();
    } else {
      user = controller.user.value;
    }

    return user;
  }

  fetchSettingsInformation() async {
    // final controller = SettingsController.instance;
    // if (controller.settings.value.id == null || controller.settings.value.id!.isEmpty) {
    //   await SettingsController.instance.fetchSettingDetails();
    // }
  }
}
