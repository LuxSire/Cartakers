import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';

class THelperFunctions {
  static DateTime getStartOfWeek(DateTime date) {
    final int daysUntilMonday = date.weekday - 1;
    final DateTime startOfWeek = date.subtract(Duration(days: daysUntilMonday));
    return DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
      0,
      0,
      0,
      0,
      0,
    );
  }

  static Color getUnitStatusColor(int value) {
    if (value == 1) {
      return Colors.green;
    } else if (value == 2) {
      return Colors.red;
    } else if (value == 3) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  static Color getUserStatusColor(int value) {
    if (value == 2) {
      return Colors.green;
    } else if (value == 1) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  static Color getUnitContractStatusColor(int value) {
    if (value == 1) {
      return Colors.green;
    } else if (value == 2) {
      return Colors.red;
    } else if (value == 3) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  static Color getStatusColor(int value) {
    if (value == 1) {
      return Colors.orange; // pending
    } else if (value == 2) {
      return Colors.orange; // in poogress
    } else if (value == 4) {
      return Colors.red; // Rejected
    } else if (value == 5) {
      return Colors.red; // cancelled
    } else if (value == 7) {
      // confirmed
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  static String getStatusText(int value) {
    if (value == 1) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_pending');
    } else if (value == 2) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_in_progress');
    } else if (value == 3) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_completed');
    } else if (value == 4) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_rejected');
    } else if (value == 5) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_cancelled');
    } else if (value == 6) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_request_submitted');
    } else if (value == 7) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_confirmed');
    } else {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_unknown');
    }
  }

  static String getUnitStatusText(int value) {
    if (value == 1) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_vacant');
    } else if (value == 2) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_occupied');
    } else {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_unknown');
    }
  }

  static String getUnitContractStatusText(int value) {
    if (value == 1) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_active');
    } else if (value == 2) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_terminated');
    } else if (value == 3) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_pending');
    } else if (value == 4) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_unassigned');
    } else {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_unassigned');
    }
  }

  static String getUserStatusText(int value) {
    if (value == 1) {
      return AppLocalization.of(
        Get.context!,
      ).translate('tab_users_screen.lbl_invited');
    } else if (value == 2) {
      return AppLocalization.of(
        Get.context!,
      ).translate('tab_users_screen.lbl_active');
    } else if (value == 3) {
      return AppLocalization.of(
        Get.context!,
      ).translate('tab_users_screen.lbl_disabled');
    } else if (value == 4) {
      return AppLocalization.of(
        Get.context!,
      ).translate('tab_users_screen.lbl_pending_invitation');
    } else {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_unassigned');
    }
  }

  static String getMessageStatusText(int value) {
    if (value == 1) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_draft');
    } else if (value == 2) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_scheduled');
    } else if (value == 3) {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_sent');
    } else {
      return AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_unknown');
    }
  }

  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static Color getMessageStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blueAccent;
      case 'sent':
        return Colors.green;
      case 'failed':
        return Colors.redAccent;
      case 'draft':
        return Colors.grey;
      default:
        return TColors.darkGrey;
    }
  }

  static Color getChannelColor(String channel) {
    switch (channel.toLowerCase()) {
      case 'email':
        return Colors.indigo;
      case 'push':
        return Colors.purple;
      case 'sms':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(
    DateTime date, {
    String format = 'dd MMM yyyy',
  }) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
        i,
        i + rowSize > widgets.length ? widgets.length : i + rowSize,
      );
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static String getDateTimeAbreviated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    //debugPrint('Difference: $difference');

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${AppLocalization.of(Get.context!).translate('time_abbreviations.s')}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${AppLocalization.of(Get.context!).translate('time_abbreviations.min')}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${AppLocalization.of(Get.context!).translate('time_abbreviations.h')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${AppLocalization.of(Get.context!).translate('time_abbreviations.d')}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${AppLocalization.of(Get.context!).translate('time_abbreviations.w')}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${AppLocalization.of(Get.context!).translate('time_abbreviations.mo')}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${AppLocalization.of(Get.context!).translate('time_abbreviations.y')}';
    }
  }

  static Future<int> getFileSizeFromUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));

      // Check if the response contains Content-Length header
      if (response.statusCode == 200) {
        // Content-Length header contains the size of the file in bytes
        final contentLength = response.headers['content-length'];
        if (contentLength != null) {
          return int.parse(contentLength);
        }
      }
    } catch (e) {
      print("Error fetching file size: $e");
    }
    return 0; // Return 0 if the file size couldn't be fetched
  }

  static String? extractFileName(String url, String containerName) {
    // Find the index of the container name in the URL
    int index = url.indexOf('$containerName/');

    // Adjust the skips based on the container name, similar to your Angular approach
    int skips = containerName == 'pmedia' ? 7 : 6;

    // If the container name exists in the URL
    if (index != -1) {
      return url.substring(
        index + skips,
      ); // Extract the part after the container name
    }

    return null; // Return null if the container name is not found
  }
}
