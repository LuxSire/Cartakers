import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          // For forcing rebuilds (do not remove, just invisible updates)
          final _ =
              controller.filteredUsers.length + controller.selectedRows.length;
          debugPrint("UsersTable rebuilt with ${controller.filteredUsers.length} users");
          return SizedBox(
            width: constraints.maxWidth,
            child: TPaginatedDataTable(
              minWidth: 900, // optional: use constraints.maxWidth if you want
              sortAscending: controller.sortAscending.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              onPaginationReset: () => controller.paginatedPage.value = 0,
              columns: [
                DataColumn2(
                  size: ColumnSize.L,
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
                    ).translate('objects_screen.lbl_object_name'),
                  ),
                  onSort:
                      (columnIndex, ascending) =>
                          controller.sortByObject(columnIndex, ascending),
                ),
                DataColumn2(
                  size: ColumnSize.M,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('users_screen.lbl_email'),
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
                    ).translate('users_screen.lbl_phone_no'),
                  ),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('users_screen.lbl_date_created'),
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
              source: UsersRows(),
            ),
          );
        });
      },
    );
  }
}
