import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_invitation_controller.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/edit_tenant.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

class TenantsInvitationRows extends DataTableSource {
  final controller = TenantInvitationController.instance;

  @override
  DataRow? getRow(int index) {
    // Use only invitation-eligible tenants
    if (index >= controller.filteredItems.length) return null;
    final tenant = controller.filteredItems[index];

    return DataRow2(
      onTap: () async {},
      selected: controller.selectedRows[index],
      onSelectChanged:
          (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tenant.fullName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (tenant.isPrimaryTenant == 1)
                Text(
                  AppLocalization.of(
                    Get.context!,
                  ).translate('tenants_screen.lbl_primary_tenant'),
                  style: const TextStyle(
                    color: TColors.alterColor,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        DataCell(Text(tenant.buildingName ?? '')),
        DataCell(Text(tenant.email)),
        DataCell(Text(tenant.contractReference ?? '')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getUserStatusColor(
              tenant.statusId ?? 0,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getUserStatusText(tenant.statusId ?? 0),
              style: TextStyle(
                color: THelperFunctions.getUserStatusColor(
                  tenant.statusId ?? 0,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Text(tenant.updatedAt == null ? '' : tenant.formattedUpdatedAtDate),
        ),
        DataCell(
          TTableActionButtons(
            view: false,
            edit: false,
            delete: false,
            sendUserInvitation: true,
            onSendUserInvitationPressed: () async {
              await controller.sendUserInvitation(tenant);
              controller.refreshData();
              // update the UI
              controller.tenantModel.refresh();
            },
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
