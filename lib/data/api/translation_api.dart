import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class TranslationApi {
  static final String _apiKey =
      dotenv.env['GOOGLE_CLOUD_API_KEY']!; // API Key from .env
  static const String _apiUrl =
      "https://translation.googleapis.com/language/translate/v2";

  /// Get the saved language code from shared preferences
  static Future<String> _getSavedLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_language') ?? _getDeviceLanguage();
  }

  /// Get the device's default language
  static String _getDeviceLanguage() {
    Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return deviceLocale.languageCode; // e.g., 'en', 'fr', 'de'
  }

  /// Translate text using Google Cloud Translation API
  static Future<String> translateOld(String text) async {
    try {
      String targetLanguage =
          await _getSavedLanguageCode(); // Get user language
      final response = await http.post(
        Uri.parse("$_apiUrl?key=$_apiKey"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'q': text, 'target': targetLanguage}),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['data']['translations'][0]['translatedText'];
      } else {
        debugPrint("Error: ${response.body}");
        return text; // Return original text if translation fails
      }
    } catch (e) {
      debugPrint("Translation error: $e");
      return text; // Return original text on error
    }
  }

  /// Detect the language code of a given text
  static Future<String> detectLanguage(String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hash = _hashText(text);
      final cached = prefs.getString('lang_detect_$hash');

      if (cached != null) return cached;

      final response = await http.post(
        Uri.parse(
          "https://translation.googleapis.com/language/translate/v2/detect?key=$_apiKey",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'q': text}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final detected = decoded['data']['detections'][0][0]['language'];
        await prefs.setString('lang_detect_$hash', detected);
        return detected;
      } else {
        debugPrint("Language detection error: ${response.body}");
        return 'und';
      }
    } catch (e) {
      debugPrint("Language detection exception: $e");
      return 'und';
    }
  }

  static Future<void> clearTranslationCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('translated_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  // clear catch for translation cache

  /// Translate text only if it's in a different language than user's
  static Future<String> smartTranslate(String text) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final targetLanguage = await _getSavedLanguageCode();
      String sourceLanguage = await detectLanguage(text);

      if (sourceLanguage == targetLanguage) return text;

      final hash = _hashTranslation(text, sourceLanguage, targetLanguage);
      final cached = prefs.getString('translated_$hash');
      if (cached != null) return cached;

      final bool isSourceSafe = RegExp(r'^[a-z]{2}$').hasMatch(sourceLanguage);

      final body = {
        'q': text,
        'target': targetLanguage,
        if (isSourceSafe) 'source': sourceLanguage,
      };

      final response = await http.post(
        Uri.parse("$_apiUrl?key=$_apiKey"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final translatedText =
            decoded['data']['translations'][0]['translatedText'];

        final unescape = HtmlUnescape();
        final cleanText = unescape.convert(translatedText);

        await prefs.setString('translated_$hash', cleanText);
        return cleanText;
      } else {
        debugPrint("Translation error: ${response.body}");
        return text;
      }
    } catch (e) {
      debugPrint("Translation failed: $e");
      return text;
    }
  }

  static String _hashText(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }

  static String _hashTranslation(
    String text,
    String sourceLang,
    String targetLang,
  ) {
    final combined = '$sourceLang->$targetLang:$text';
    return sha256.convert(utf8.encode(combined)).toString();
  }
}

// class TranslationApi {
//   static final GoogleTranslator _translator = GoogleTranslator();

//   /// Get the saved language code from shared preferences
//   static Future<String> _getSavedLanguageCode() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selected_language') ?? _getDeviceLanguage();
//   }

//   /// Get the device's default language
//   static String _getDeviceLanguage() {
//     Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
//     return deviceLocale.languageCode; // e.g., 'en', 'fr', 'de'
//   }

//   /// Detects the language of the given text
//   static Future<String> detectLanguage(String text) async {
//     try {
//       final detectedLanguage = await _translator.translate(text);
//       return detectedLanguage.sourceLanguage.code;
//     } catch (e) {
//       debugPrint('Error detecting language: $e');
//       return 'de'; // Default to german if detection fails
//     }
//   }

//   /// Translate text with automatic language detection
//   static Future<String> translate(String text) async {
//     try {
//       String fromLanguageCode =
//           await detectLanguage(text); // Detect source language
//       String toLanguageCode =
//           await _getSavedLanguageCode(); // Get target language

//       if (fromLanguageCode == toLanguageCode) {
//         return text; // No need to translate if the source and target are the same
//       }

//       final translation = await _translator.translate(
//         text,
//         from: fromLanguageCode,
//         to: toLanguageCode,
//       );

//       return translation.text;
//     } catch (e) {
//       debugPrint('Translation error: $e');
//       return text; // Return original text on error
//     }
//   }
// }

// import 'package:translator/translator.dart';

// class TranslationApi {
//   static Future<String> translate(
//       String text, String fromLanguageCode, String toLanguageCode) async {
//     // use try catch in case of error and just return the text

//     try {
//       final translation = await GoogleTranslator()
//           .translate(text, from: fromLanguageCode, to: toLanguageCode);
//       return translation.text;
//     } catch (e) {
//       return text;
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';

// class TranslationApi {
//   static const String apiKey = 'YOUR_GOOGLE_CLOUD_API_KEY';
//   static const String apiUrl = 'https://translation.googleapis.com/language/translate/v2';

//   /// Get the saved language code from shared preferences
//   static Future<String> _getSavedLanguageCode() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selected_language') ?? _getDeviceLanguage();
//   }

//   /// Get the device's default language
//   static String _getDeviceLanguage() {
//     Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
//     return deviceLocale.languageCode; // e.g., 'en', 'fr', 'de'
//   }

//   /// Translate text with Google Cloud API
//   static Future<String> translate(String text) async {
//     try {
//       String targetLanguage = await _getSavedLanguageCode();

//       final response = await http.post(
//         Uri.parse('$apiUrl?key=$apiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'q': text,
//           'target': targetLanguage,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final decodedResponse = jsonDecode(response.body);
//         return decodedResponse['data']['translations'][0]['translatedText'];
//       } else {
//         debugPrint('Translation error: ${response.body}');
//         return text; // Return original text on error
//       }
//     } catch (e) {
//       debugPrint('Translation error: $e');
//       return text;
//     }
//   }
// }
