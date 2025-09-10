import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/app/utils/helpers.dart';
import 'package:xm_frontend/data/api/services/user_service.dart';
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
class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Whether the password should be hidden
  final hidePassword = true.obs;

  /// Whether the user has selected "Remember Me"
  final rememberMe = false.obs;

  /// Local storage instance for remembering email and password
  final localStorage = GetStorage();

  /// Text editing controller for the email field
  final email = TextEditingController();

  /// Text editing controller for the password field
  final password = TextEditingController();

  /// Form key for the login form
  final loginFormKey = GlobalKey<FormState>();

  final forgotPasswordFormKey = GlobalKey<FormState>();

  final otpController = TextEditingController();

  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final hideForgotPassword = false.obs;

  final showNewPassword = false.obs;

  var userId = 0.obs;

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';

    // if remember me is selected, set the value to true
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      rememberMe.value = true;
    }

    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      // before reset values
      await AuthenticationRepository.instance.reset();

      // Start Loading
      TFullScreenLoader.openLoadingDialog('...', TImages.buildingsIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Login user using Email & Password Authentication
      bool isValidLogin = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      //  debugPrint('isLoggedIn: $isValidLogin');

      // debugPrint('User: ${user.displayName}');

      // Remove Loader
      TFullScreenLoader.stopLoading();

      //  debugPrint('User ID tell me : ${isValidLogin}');

      if (isValidLogin) {
        // debugPrint('Here : ${isValidLogin}');

        localStorage.write('DISPLAY_INVITATION_SCREEN', false);

        // User Information
        final user = await fetchUserInformation();

        await localStorage.write('AUTH_TOKEN', user.toJson());
        // await localStorage.write('AUTH_TOKEN', "hello");

        AuthenticationRepository.instance.currentUser = user;

        Get.offAllNamed(Routes.dashboard);
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_failed'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('login_screen.err_msg_invalid_credentials'),
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

  Future<void> sendPasswordResetEmail(
    BuildContext context,
    String email,
  ) async {
    try {
      // Form Validation
      if (!forgotPasswordFormKey.currentState!.validate()) {
        //  TFullScreenLoader.stopLoading();
        return;
      }

      // Call backend to fetch tenant data by email
      final userService = UserService();

      final greetings = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_hello');
      final bodyText = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_body_text_reset_passsword');
      final resetCodeText = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_reset_code_text');
      final availableOnText = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_available_on');
      final helpText = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_help_text');
      final supportText = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_support_text');
      final subject = AppLocalization.of(
        context,
      ).translate('general_msgs.msg_mail_subject_reset_password');

      final resetCode = Helpers.generateRandomNumber();

      debugPrint('Login Controller : resetCode: $resetCode');
      // first check if email exists
      final responseUser = await userService.getUserByEmail(email);
      debugPrint('responseUser: $responseUser');
      if ((responseUser['id'] ?? 0) > 0) {
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_failed'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_no_data_found'),
        );
        return;
      }
      debugPrint('Login Controller : User Exists');
      debugPrint('Login Controller : resetCode: $resetCode');
      debugPrint('Login Controller : email: $email');

      final responseUpdateResetCode = await userService
          .updateUserResetPasswordCode(email, resetCode.toString());

      debugPrint('responseUpdateResetCode: $responseUpdateResetCode');

      final response = await userService.sendUserPasswordResetEmail(
        email,
        greetings,
        bodyText,
        resetCodeText,
        resetCode.toString(),
        availableOnText,
        helpText,
        supportText,
        subject,
      );

      //debugPrint('response: $response');
      bool isSuccess = response['success'];
      if (isSuccess) {
        hideForgotPassword.value = true;
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_failed'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('login_screen.lbl_password_reset_failed'),
        );
      }
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
    }
  }

  Future<void> verifyCode(BuildContext context) async {
    try {
      // Call backend to fetch tenant data by email
      final userService = UserService();

      final responseVerify = await userService.getUserByResetCode(
        email.text,
        otpController.text,
      );

      //   // debugPrint('responseVerify: $responseVerify');

      //   // debugPrint('responseVerify: ${responseVerify['id']}');

      if (responseVerify['id'] > 0) {
        userId.value = responseVerify['id'];
        showNewPassword.value = true;
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_failed'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('forgot_password_screen.err_msg_please_enter_valid_otp'),
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_failed'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('forgot_password_screen.err_msg_please_enter_valid_otp'),
      );
    }
  }

  Future<void> updatePassword(BuildContext context) async {
    try {
      // check if new password and confirm password match
      if (newPasswordController.text.isEmpty ||
          confirmNewPasswordController.text.isEmpty) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_failed'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_please_fill_all_the_required_fields'),
        );

        return;
      }

      if (newPasswordController.text != confirmNewPasswordController.text) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_failed'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('register_screen.err_msg_passwords_do_not_match'),
        );

        return;
      }

      final userService = UserService();

      String plainPassword = newPasswordController.text.trim();
      String hashedPassword = Helpers.hashPassword(plainPassword);

      await userService.updateUserPassword(
        userId.value,
        hashedPassword, // Use hashed password
      );

      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_success'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('reset_password_screen.success_msg_password_updated'),
      );

      // go to login screen
      Get.offAllNamed(Routes.login);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_failed'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('forgot_password_screen.err_msg_password_update_failed'),
      );
    }
  }

  fetchSettingsInformation() async {
    // final controller = SettingsController.instance;
    // if (controller.settings.value.id == null || controller.settings.value.id!.isEmpty) {
    //   await SettingsController.instance.fetchSettingDetails();
    // }
  }
}
