import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/app/localization/app_localization_delegate.dart';
import 'package:xm_frontend/bindings/general_bindings.dart';
import 'package:xm_frontend/routes/route_observer.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/routes/app_routes.dart';
import 'package:xm_frontend/common/widgets/page_not_found/page_not_found.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/text_strings.dart';
import 'package:xm_frontend/utils/device/web_material_scroll.dart';
import 'package:xm_frontend/utils/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Put your AppController so it's available everywhere
  Get.put(AppController());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // find your controller once
    final appCtrl = Get.find<AppController>();

    // wrap your GetMaterialApp in Obx to react to changes
    return Obx(() {
      // keep Intl in sync
      Intl.defaultLocale = appCtrl.locale.value.toString();

      return GetMaterialApp(
        title: TTexts.appName,
        debugShowCheckedModeBanner: false,

        // ─── THEMES ─────────────────────────────────────────
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode:
            appCtrl.themeMode.value == 'light'
                ? ThemeMode.light
                : appCtrl.themeMode.value == 'dark'
                ? ThemeMode.dark
                : ThemeMode.system,

        // ─── LOCALIZATION ────────────────────────────────────
        locale: appCtrl.locale.value,
        fallbackLocale: const Locale('en', 'US'),
        supportedLocales: const [
          Locale('de', 'DE'),
          Locale('fr', 'FR'),
          Locale('it', 'IT'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // ─── NAVIGATION ──────────────────────────────────────
        initialBinding: GeneralBindings(),
        navigatorObservers: [RouteObservers()],
        scrollBehavior: MyCustomScrollBehavior(),
        initialRoute: Routes.splash,
        getPages: AppRoute.pages,
        unknownRoute: GetPage(
          name: '/page-not-found',
          page:
              () => TPageNotFound(
                isFullPage: true,
                title: "Oops! You've Ventured into the Abyss of the Internet!",
                subTitle:
                    "Looks like you've discovered the Bermuda Triangle of our app. Don't worry, we won’t let you stay lost forever. Click the button below to return to safety!",
              ),
        ),

        // ─── SPLASH/HOME ────────────────────────────────────
        home: Scaffold(
          backgroundColor: TColors.primary,
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    });
  }
}
