import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/document/document_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';

class RenameFileDialog extends StatelessWidget {
  final String currentFileName;
  final String documentId;

  RenameFileDialog({
    super.key,
    required this.currentFileName,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = DocumentController.instance;

    controller.renameDocumentController.text = currentFileName;

    return AlertDialog(
      backgroundColor: TColors.white,
      title: Text(
        AppLocalization.of(Get.context!).translate('general_msgs.msg_rename'),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            // Display the current file name
            // Text(
            //   AppLocalization.of(
            //     Get.context!,
            //   ).translate('general_msgs.msg_file_name'),
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            //  Text(currentFileName), // Show current file name
            //  SizedBox(height: 20),

            // TextField for entering a new file name
            TextField(
              controller: controller.renameDocumentController,
              decoration: InputDecoration(
                labelText: AppLocalization.of(
                  Get.context!,
                ).translate('general_msgs.msg_file_name'),
                hintText: AppLocalization.of(
                  Get.context!,
                ).translate('general_msgs.msg_enter_new_file_name'),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_cancel'),
          ),
        ),
        // Update button
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: TColors.primary,
            foregroundColor: TColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),

          onPressed: () {
            // Get the new file name from the controller
            String newFileName =
                controller.renameDocumentController.text.trim();

            if (newFileName.isNotEmpty) {
              final contractController = ContractController.instance;
              // close dialog

              contractController.renameFile(documentId, newFileName);
            }
          },
          child: Text(
            AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_update'),
          ),
        ),
      ],
    );
  }
}
