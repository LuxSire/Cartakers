import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cartakers/app/utils/user_preferences.dart';
import 'package:cartakers/data/models/user_pref_model.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/routes/routes.dart';

import 'splash_design.dart';

class SplashController extends StatefulWidget {
  const SplashController({super.key});

  @override
  _SplashControllerState createState() => _SplashControllerState();
}

class _SplashControllerState extends State<SplashController> {
  final localStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    // reset values
    await AuthenticationRepository.instance.reset();

    // Let splash screen show for 2 seconds
    await Future.delayed(const Duration(seconds: 3));

    UserPrefModel? user = await UserPreferences.getUser();

    // await UserPreferences.updateUserField("has_logged_in", false);

    //  final isUserRegistered = user?.hasRegistered ?? false;

    final displayInvitationScreen =
        localStorage.read('DISPLAY_INVITATION_SCREEN') ?? true;

    // debugPrint('Display Invitation Screen: $displayInvitationScreen');

    final hasUserLoggedIn = user?.hasLoggedIn ?? false;
    final isAutoLogin = user?.isAutoLogin ?? false;

    debugPrint(hasUserLoggedIn.toString());

    if (displayInvitationScreen) {
      Get.offAllNamed(Routes.invitation);
    } else if (!isAutoLogin) {
      Get.offAllNamed(Routes.login);
    } else {
      Get.offAllNamed(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashDesign();
  }
}
