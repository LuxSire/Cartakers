import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cartakers/app/app_controller.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/app/utils/user_preferences.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/sizes.dart';
const _flagEmojis = {'de': '🇩🇪', 'fr': '🇫🇷', 'it': '🇮🇹', 'en': '🇬🇧'};

class PreferencesTab extends StatefulWidget {
  const PreferencesTab({Key? key}) : super(key: key);

  @override
  _PreferencesTabState createState() => _PreferencesTabState();
}

class _PreferencesTabState extends State<PreferencesTab> {
  final AppController _appCtrl = Get.find();
  bool _pushNotifications = false;
  bool _emailReminders = false;
  String _themeMode = 'light'; // 'system', 'light', or 'dark'
  late Locale _locale;

  final localStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    // load initial toggles from SharedPreferences / your persisted user

    // UserPreferences.getPushNotificationsEnabled().then((v) {
    //   setState(() => _pushNotifications = v);
    // });

    // UserPreferences.getEmailNotificationsEnabled().then((v) {
    //   setState(() => _emailReminders = v);
    // });

    _pushNotifications = localStorage.read('PUSH_NOTIFICATIONS') ?? false;
    _emailReminders = localStorage.read('EMAIL_REMINDERS') ?? false;

    // load theme & language from controller
    _themeMode = _appCtrl.themeMode.value;
    _locale = _appCtrl.locale.value;
  }

  Widget _sectionHeader(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const langs = ['de', 'fr', 'it', 'en'];

    return ListView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      children: [
        // ── Notifications ─────────────────────────────
        _sectionHeader(
          AppLocalization.of(
            context,
          ).translate('tab_preferences_screen.lbl_notifications'),
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0.5,
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              SwitchListTile(
                activeColor: TColors.primary,
                title: Text(
                  AppLocalization.of(
                    context,
                  ).translate('tab_preferences_screen.lbl_push_notifications'),
                ),
                value: _pushNotifications,
                onChanged: (v) {
                  setState(() => _pushNotifications = v);

                  // //  UserPreferences.setPushNotificationsEnabled(v);
                  // _appCtrl.setPushNotifications(v); // update controller state
                  localStorage.write('PUSH_NOTIFICATIONS', v);
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                activeColor: TColors.primary,
                title: Text(
                  AppLocalization.of(
                    context,
                  ).translate('tab_preferences_screen.lbl_email_notifications'),
                ),
                value: _emailReminders,
                onChanged: (v) {
                  setState(() => _emailReminders = v);
                  //  UserPreferences.setEmailNotificationsEnabled(v);
                  // _appCtrl.setEmailNotifications(v); // update controller state

                  localStorage.write('EMAIL_REMINDERS', v);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // ── Language ─────────────────────────────────
        _sectionHeader(
          AppLocalization.of(
            context,
          ).translate('tab_preferences_screen.lbl_language'),
        ),
        Row(
          children: [
            // narrow dropdown so it doesn't fill entire width
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  value: _locale.languageCode,
                  items:
                      langs.map((code) {
                        final flag = _flagEmojis[code] ?? code.toUpperCase();
                        return DropdownMenuItem(
                          value: code,
                          child: Row(
                            children: [
                              Text(flag, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 6),
                              Text(code.toUpperCase()),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (newCode) {
                    if (newCode != null &&
                        newCode != _appCtrl.locale.value.languageCode) {
                      _appCtrl.changeLanguage(Locale(newCode));
                      setState(() => _locale = Locale(newCode));
                    }
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // ── Theme ────────────────────────────────────
        // _sectionHeader(
        //   AppLocalization.of(
        //     context,
        //   ).translate('tab_preferences_screen.lbl_theme'),
        // ),
        Column(
          children: [
            // RadioListTile<String>(
            //   title: Text(
            //     AppLocalization.of(
            //       context,
            //     ).translate('tab_preferences_screen.lbl_system_mode'),
            //   ),
            //   value: 'system',
            //   groupValue: _themeMode,
            //   onChanged: (v) {
            //     if (v != null) {
            //       setState(() => _themeMode = v);
            //       _appCtrl.changeThemeMode(v);
            //     }
            //   },
            // ),
            // RadioListTile<String>(
            //   activeColor: TColors.primary,
            //   title: Text(
            //     AppLocalization.of(
            //       context,
            //     ).translate('tab_preferences_screen.lbl_light_mode'),
            //   ),
            //   value: 'light',
            //   groupValue: _themeMode,
            //   onChanged: (v) {
            //     if (v != null) {
            //       setState(() => _themeMode = v);
            //       _appCtrl.changeThemeMode(v);
            //     }
            //   },
            // ),
            // RadioListTile<String>(
            //   title: Text(
            //     AppLocalization.of(
            //       context,
            //     ).translate('tab_preferences_screen.lbl_dark_mode'),
            //   ),
            //   value: 'dark',
            //   groupValue: _themeMode,
            //   onChanged: (v) {
            //     if (v != null) {
            //       setState(() => _themeMode = v);
            //       _appCtrl.changeThemeMode(v);
            //     }
            //   },
            // ),
          ],
        ),
      ],
    );
  }
}
