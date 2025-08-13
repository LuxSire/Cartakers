import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/controllers/document/document_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/all_contracts/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/contract/all_contracts/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/features/shop/screens/document/file_detail_dialog.dart';
import 'package:xm_frontend/features/shop/screens/document/file_rename_dialog.dart';
import 'package:xm_frontend/features/shop/screens/document/img_viewer_page.dart';
import 'package:xm_frontend/features/shop/screens/document/pdf_viewer_page.dart';
import 'package:xm_frontend/features/shop/screens/document/web_view_page.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

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
