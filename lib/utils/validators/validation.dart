import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';

/// VALIDATION CLASS
class TValidator {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName${AppLocalization.of(Get.context!).translate('general_msgs.msg_is_required')}';
    }

    return null;
  }

  /// Username Validation
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required.';
    }

    // Define a regular expression pattern for the username.
    const pattern = r"^[a-zA-Z0-9_-]{3,20}$";

    // Create a RegExp instance from the pattern.
    final regex = RegExp(pattern);

    // Use the hasMatch method to check if the username matches the pattern.
    bool isValid = regex.hasMatch(username);

    // Check if the username doesn't start or end with an underscore or hyphen.
    if (isValid) {
      isValid =
          !username.startsWith('_') &&
          !username.startsWith('-') &&
          !username.endsWith('_') &&
          !username.endsWith('-');
    }

    if (!isValid) {
      return 'Username is not valid.';
    }

    return null;
  }

  /// Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_email_address_is_required');
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_invalid_email_adddress');
    }

    return null;
  }

  /// Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_password_is_required');
    }

    // Check for minimum password length
    if (value.length < 6) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_password_must');
    }

    // Check for uppercase letters
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain at least one uppercase letter.';
    // }

    // // Check for numbers
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Password must contain at least one number.';
    // }

    // // Check for special characters
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password must contain at least one special character.';
    // }

    return null;
  }

  static String? validatePasswordConfirmation(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppLocalization.of(
        Get.context!,
      ).translate('register_screen.err_msg_please_enter_confirm_password');
    }

    if (password != confirmPassword) {
      return AppLocalization.of(
        Get.context!,
      ).translate('register_screen.err_msg_passwords_do_not_match');
    }

    return null;
  }

  /// Phone Number Validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{12}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (12 digits required).';
    }

    return null;
  }

  // Add more custom validators as needed for your specific requirements.
}
