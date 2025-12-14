import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/loaders/animation_loader.dart';
import 'package:cartakers/data/models/permission_model.dart';
import 'package:cartakers/data/models/docs_model.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
import 'package:cartakers/features/shop/controllers/document/document_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/shop/screens/contract/all_contracts/table/data_table.dart';
import 'package:cartakers/features/shop/screens/contract/all_contracts/widgets/table_header.dart';
import 'package:cartakers/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:cartakers/features/shop/screens/document/file_detail_dialog.dart';
import 'package:cartakers/features/shop/screens/document/file_rename_dialog.dart';
import 'package:cartakers/features/shop/screens/document/img_viewer_page.dart';
import 'package:cartakers/features/shop/screens/document/pdf_viewer_page.dart';
import 'package:cartakers/features/shop/screens/document/web_view_page.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/device/device_utility.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';
class PermissionsTab extends StatelessWidget {
  const PermissionsTab({super.key});
   
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          PermissionTableHeader(),
          SizedBox(height: TSizes.spaceBtwItems),
          // Table
          PermissionsTable(),
        ],
      ),
    );
  }
}
