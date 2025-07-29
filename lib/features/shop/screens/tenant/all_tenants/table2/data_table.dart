import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_invitation_controller.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class TenantsInvitationTable extends StatelessWidget {
  const TenantsInvitationTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantInvitationController());

    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          final _ =
              controller.filteredItems.length + controller.selectedRows.length;

          return SizedBox(
            width: constraints.maxWidth,
            child: TPaginatedDataTable(
              minWidth: 900,
              sortAscending: controller.sortAscending.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              onPaginationReset: () => controller.paginatedPage.value = 0,
              columns: [
                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('tenants_screen.lbl_tenant_name'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByName(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('buildings_screen.lbl_building_name'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByBuilding(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.M,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('tenants_screen.lbl_email'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByEmail(columnIndex, ascending),
                ),

                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('tenants_screen.lbl_contract_reference'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByContract(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('tab_users_screen.lbl_status'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByStatus(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('tab_app_invitation_screen.lbl_updated_on'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByCreatedAt(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  fixedWidth: 130,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('tenants_screen.lbl_actions'),
                  ),
                ),
              ],
              source: TenantsInvitationRows(),
            ),
          );
        });
      },
    );
  }
}
