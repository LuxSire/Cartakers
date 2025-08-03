import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/data/repositories/company/company_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/utils/helpers/network_manager.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/personalization/controllers/user_controller.dart';
import 'features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Storage
  await GetStorage.init();

  // Load environment variables
  const String envFile = String.fromEnvironment('ENV', defaultValue: 'dev');
  await dotenv.load(fileName: '.env.$envFile');

  if (kDebugMode) {
    print('API URL: ${dotenv.env['API_URL']}');
  }

  // Register Dependencies
  Get.put(AppController());
  Get.put(AuthenticationRepository());
  Get.put(CompanyRepository());
  Get.put(UserController()); // personalization version ONLY
  Get.put(SettingsController());
  Get.put(DashboardController());
  Get.put(UserRepository());

  AuthenticationRepository.instance.restoreSession();

  ///  Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Caught Flutter error: ${details.exceptionAsString()}');
  };

  ///  Catch async errors (e.g., in Futures, API calls)
  runZonedGuarded(
    () {
      runApp(OverlaySupport.global(child: App()));
    },
    (error, stackTrace) {
      print('Caught async error: $error');
      print('Stack trace: $stackTrace');
    },
  );
}
