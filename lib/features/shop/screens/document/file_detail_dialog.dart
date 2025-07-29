import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class FileDetailsDialog extends StatelessWidget {
  final String fileName;
  final String fileType;

  final DateTime
  creationDate; // Assuming you have a DateTime value for creation date
  final int fileSize; // File size in bytes
  final String createdBy;

  const FileDetailsDialog({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.creationDate,
    required this.fileSize,
    required this.createdBy,
  });

  @override
  Widget build(BuildContext context) {
    // Formatting the date

    String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(creationDate);

    // Convert file size from bytes to KB/MB/GB
    String formattedSize = _formatFileSize(fileSize);

    return AlertDialog(
      backgroundColor: TColors.white,
      //   title: Text('File Details'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            _buildDetailColumn(
              AppLocalization.of(
                Get.context!,
              ).translate('contract_screen.lbl_file_name'),
              fileName,
            ),
            _buildDetailColumn(
              AppLocalization.of(
                Get.context!,
              ).translate('contract_screen.lbl_file_type'),
              fileType,
            ),
            _buildDetailColumn(
              AppLocalization.of(
                Get.context!,
              ).translate('contract_screen.lbl_created_on'),
              formattedDate,
            ),
            _buildDetailColumn(
              AppLocalization.of(
                Get.context!,
              ).translate('contract_screen.lbl_uploaded_by'),
              createdBy,
            ),
            _buildDetailColumn(
              AppLocalization.of(
                Get.context!,
              ).translate('contract_screen.lbl_file_size'),
              formattedSize,
            ),
            // You can add more details as needed
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_close'),
          ),
        ),
      ],
    );
  }

  // Helper function to format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    }
  }

  // Helper function to build a row with a title and value
  Widget _buildDetailColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
