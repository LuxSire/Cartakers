import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xm_frontend/services/theme_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/data/repositories/company/company_repository.dart';

import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/utils/helpers/network_manager.dart';
import 'package:xm_frontend/data/repositories/media/media_repository.dart';
import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/personalization/controllers/user_controller.dart';
import 'features/personalization/controllers/company_controller.dart';
import 'features/shop/controllers/object/object_controller.dart';
import 'features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'features/shop/controllers/document/document_controller.dart';
import 'features/shop/controllers/contract/permission_controller.dart';
import 'features/shop/controllers/communication/communication_controller.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      Get.put(ThemeService());
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
  debugPrint('AuthenticationRepository instance created');

//  Get.put(UserRepository()); // personalization version ONLY
//  debugPrint('UserRepository instance created');

  Get.put(UserController()); // personalization version ONLY
  debugPrint('UserController instance created');
//  Get.put(ObjectController());
 // debugPrint('ObjectController instance created');
  /*
  Get.put(ObjectController());
    debugPrint('ObjectController instance created');
*/
  Get.put(SettingsController());
  debugPrint('SettingsController instance created');
  Get.put(DashboardController());
  debugPrint('DashboardController instance created');
  Get.put(MediaRepository());
  debugPrint('MediaRepository  instance created');
 // Get.put(CompanyRepository());
 // debugPrint('CompanyRepository instance created');
  Get.put(CompanyController());
  debugPrint('CompanyController instance created');
  Get.put(PermissionController()); // shop version ONLY
  debugPrint('PermissionController instance created');
  Get.put(DocumentController());
  debugPrint('DocumentController instance created');
  Get.put(CommunicationController());
  debugPrint('Communication instance created');

  Get.put(ObjectController());
  debugPrint('Object instance created');


  try {
  AuthenticationRepository.instance.restoreSession();


  ///  Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Caught Flutter error: ${details.exceptionAsString()}');
  };
} catch (e, stack) {
  print('Error restoring session: $e');
  print(stack);
}
  ///  Catch async errors (e.g., in Futures, API calls)

      
      runApp(OverlaySupport.global(child: App()));
    },
    (error, stackTrace) {
      print('Caught async error: $error');
      print('Stack trace: $stackTrace');
    },
  );
}
