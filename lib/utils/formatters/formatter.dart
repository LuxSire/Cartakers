import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';

class TFormatter {
  static String formatDateAndTime(DateTime? date) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd.MM.yyyy').format(date);
    final onlyTime = DateFormat('HH:mm').format(date);
    return '$onlyDate at $onlyTime';
  }

  static String formatDate(DateTime? date) {
    try {
      date;
      final onlyDate = DateFormat('dd.MM.yyyy').format(date!);
      return onlyDate;
    } catch (e) {
      // Handle the error if date is null or invalid
      return '';
    }
  }

  static String formatDateTimeWithText(
    DateTime? date, {
    Locale? overrideLocale,
  }) {
    final dt = date ?? DateTime.now();

    // 1) choose locale: override? Get.locale? default?
    final code =
        overrideLocale?.toLanguageTag() ??
        Get.locale?.toLanguageTag() ??
        Intl.getCurrentLocale();
    // 2) ensure Intl.defaultLocale is set (so internal routines know it):
    Intl.defaultLocale = code;

    // 3) you can either build one pattern:
    return DateFormat("d MMMM yyyy, HH:mm", code).format(dt);
  }

  static String formatDateWithText(DateTime? date, {Locale? overrideLocale}) {
    final dt = date ?? DateTime.now();

    // 1) choose locale: override? Get.locale? default?
    final code =
        overrideLocale?.toLanguageTag() ??
        Get.locale?.toLanguageTag() ??
        Intl.getCurrentLocale();
    // 2) ensure Intl.defaultLocale is set (so internal routines know it):
    Intl.defaultLocale = code;

    // 3) you can either build one pattern:
    return DateFormat("d MMMM yyyy", code).format(dt);
  }

  static String formatDateShorted(DateTime? date, BuildContext context) {
    date ??= DateTime.now();
    final now = DateTime.now();

    // debugPrint('date: $date');
    // debugPrint('now: $now');
    // debugPrint('date time zone: ${date.timeZoneName}');
    // debugPrint('now time zone: ${now.timeZoneName}');

    final difference = now.difference(date);
    // debugPrint('difference: $difference');

    if (difference.isNegative) {
      return AppLocalization.of(
        context,
      ).translate('time_abbreviations.just_now'); // Prevents negative values
    }

    final daysDiff =
        now.day - date.day; // Calculate the difference in calendar days

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${AppLocalization.of(context).translate('time_abbreviations.s')}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${AppLocalization.of(context).translate('time_abbreviations.min')}';
    } else if (difference.inHours < 24 && daysDiff == 0) {
      return '${difference.inHours} ${AppLocalization.of(context).translate('time_abbreviations.h')}';
    } else if (daysDiff == 1) {
      return AppLocalization.of(
        context,
      ).translate('time_abbreviations.yesterday');
    } else if (daysDiff > 1) {
      return '$daysDiff ${AppLocalization.of(context).translate('time_abbreviations.d')}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${AppLocalization.of(context).translate('time_abbreviations.w')}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${AppLocalization.of(context).translate('time_abbreviations.mo')}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${AppLocalization.of(context).translate('time_abbreviations.y')}';
    }
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    ).format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Assuming a 10-digit US phone number format: (123) 456-7890
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    // Add more custom phone number formatting logic for different formats if needed.
    return phoneNumber;
  }

  // Not fully tested.
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Extract the country code from the digitsOnly
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // Add the remaining digits with proper formatting
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }

    return formattedNumber.toString();
  }
}
