import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class TLoaders {
  static hideSnackBar() {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } else {
      debugPrint('❌ Get.context is null. Cannot hide snackbar.');
    }
  }

  static customToast({required message}) {
    final context = Get.context;
    if (context == null) {
      debugPrint('❌ Get.context is null. Skipping customToast.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 500,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color:
                THelperFunctions.isDarkMode(context)
                    ? TColors.darkerGrey.withOpacity(0.9)
                    : TColors.grey.withOpacity(0.9),
          ),
          child: Center(
            child: Text(message, style: Theme.of(context).textTheme.labelLarge),
          ),
        ),
      ),
    );
  }

  static successSnackBar({required title, message = '', duration = 3}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        maxWidth: 600,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: TColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.check, color: TColors.white),
      );
    } else {
      debugPrint('❌ Tried to show snackbar but Get.context is null.');
    }
  }

  static warningSnackBar({required title, message = ''}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        maxWidth: 600,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white),
      );
    } else {
      debugPrint('❌ Tried to show snackbar but Get.context is null.');
    }
  }

  static errorSnackBar({required title, message = ''}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        maxWidth: 600,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white),
      );
    } else {
      debugPrint('❌ Tried to show snackbar but Get.context is null.');
    }
  }
}
