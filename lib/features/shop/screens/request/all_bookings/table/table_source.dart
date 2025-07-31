import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/update_request.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/edit_user.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class RequestsRows extends DataTableSource {
  final controller = Get.find<RequestController>(tag: 'agency_requests');

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length)
      return null; // prevent overflow

    final request = controller.filteredItems[index];
    return DataRow2(
      //   onTap: () async {},
      //  selected: controller.selectedRows[index],
      //    onSelectChanged:
      //      (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TCircularImage(
                width: 30,
                height: 30,
                padding: 2,
                fit: BoxFit.cover,
                backgroundColor: TColors.primaryBackground,
                image:
                    request.createdByUserProfileImageUrl!.isNotEmpty
                        ? request.createdByUserProfileImageUrl
                        : TImages.user,
                imageType:
                    request.createdByUserProfileImageUrl!.isNotEmpty
                        ? ImageType.network
                        : ImageType.asset,
              ),

              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      request.createdByName ?? '',

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(request.objectName!)),
        DataCell(Text(request.ticketNumber ?? '')),
        DataCell(Text(request.getTranslatedRequestTypeSync())),
        DataCell(Text(request.description!)),
        DataCell(Text(request.formattedDateTimeWithText)),

        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getStatusColor(
              request.status!,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getStatusText(request.status!),
              style: TextStyle(
                color: THelperFunctions.getStatusColor(request.status!),
              ),
            ),
          ),
        ),

        DataCell(
          TTableActionButtons(
            view: false,
            edit: true,

            onViewPressed: () {},

            onEditPressed: () async {
              final updatedRequest = await showDialog<RequestModel>(
                context: Get.context!,
                barrierDismissible: false,
                builder:
                    (_) => UpdateRequestDialog(
                      request: request,
                      tag: 'company_requests',
                    ),
              );

              if (updatedRequest != null) {
                controller.refreshData();
              }
            },

            delete: false,
            // onDeletePressed: () => controller.confirmAndDeleteItem(booking),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
