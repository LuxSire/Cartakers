import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
import 'package:cartakers/features/shop/controllers/user/user_invitation_controller.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class UsersInvitationTable extends StatelessWidget {
  const UsersInvitationTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserInvitationController());

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
                    ).translate('users_screen.lbl_user_name'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByName(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.M,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('objects_screen.lbl_email'),
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
                    ).translate('users_screen.lbl_actions'),
                  ),
                ),
              ],
              source: UsersInvitationRows(),
            ),
          );
        });
      },
    );
  }
}
