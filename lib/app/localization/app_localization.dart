import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;
  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  Map<String, dynamic>? _localizedStrings;

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/translations/${locale.languageCode}.json');
      _localizedStrings = json.decode(jsonString);
      return true;
    } catch (e) {
      debugPrint('Error loading localization: $e');
      return false;
    }
  }

  // Updated translate method to support nested keys
  String translate(String key) {
    if (_localizedStrings == null) {
      debugPrint('Localization not loaded: $key');
      return key;
    }
    List<String> keys = key.split('.'); // Split the key by dot notation
    dynamic value = _localizedStrings;

    for (String k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return key; // Return the key as a fallback if translation is missing
      }
    }

    return value is String
        ? value
        : key; // Return the final value or key if not found
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => [
        'de',
        'fr',
        'it',
        'en',
      ].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
