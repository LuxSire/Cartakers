import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/app/utils/helpers.dart';
import 'package:xm_frontend/app/utils/user_preferences.dart';
import 'package:xm_frontend/data/models/company_invitation_model.dart';
import 'package:xm_frontend/data/models/user_pref_model.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/routes/routes.dart';

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
class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  /// Whether the password should be hidden
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  /// Local storage instance for remembering ....
  final localStorage = GetStorage();

  /// Text editing controller for the firtsName field
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final companyName = ''.obs;
  final address = ''.obs;
  final companyId = 0.obs;

  final invitationId = 0.obs;

  /// Form key for the register form
  final registerFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    super.onInit();
  }

  /// Init Data
  void init(CompanyInvitationModel companyModel) {
    debugPrint(companyModel.companyName);
    firstName.text = companyModel.FirstName;
    lastName.text = companyModel.LastName;
    email.text = companyModel.email;
    phoneNumber.text = companyModel.PhoneNumber;
    companyName.value = companyModel.companyName;
    companyId.value = companyModel.companyId;
    invitationId.value = companyModel.id;
    address.value = companyModel.address;
  }

  /// Handles email and password sign-in process
  Future<void> registerAdmin() async {
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
      if (!registerFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // password needs to be hashed before sending to the backend
      String plainPassword = password.text;
      String hashedPassword = Helpers.hashPassword(plainPassword);

      final userJson = { 
      'email': email.text,
      'password': hashedPassword,
      'first_name': firstName.text,
      'last_name': lastName.text,
      'company_id': companyId.value.toString(),
      };

      // Login user using Email & Password Authentication
      final registerResponse = await AuthenticationRepository.instance
          .registerUser(
           userJson
          );

      debugPrint('[Register Controller] Register Admin Register Response: $registerResponse'); 

      // Remove Loader
      TFullScreenLoader.stopLoading();

      if (registerResponse.isNotEmpty) {
        // Store User Details

        try {
          UserPrefModel user = UserPrefModel(
            id: companyId.value.toString(),
            displayName: '${firstName.text} ${lastName.text}',
            hasLoggedIn: false,
            hasRegistered: true,
            email: email.text,
            agencyId: 0, //
            roleId: 0, //
            roleName: '',
            isAutoLogin: false,
          );

          // update flags
          final userController = UserController.instance;
/*
          await userController.userRepository.updateUserInvitationStatus(
            invitationId.value,
            2, // 2 accepted invitation
          );
          await userController.userRepository.updateUserStatus(
            companyId.value,
            2, // 2 Active
          );
*/
          await UserPreferences.saveUser(user);
        } catch (e) {
          debugPrint('Error saving user: $e');
        }
        debugPrint('registerResponse: : $registerResponse');

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_success'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('register_screen.success_msg_registration_success'),
        );

        Get.toNamed(Routes.login);
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
}
