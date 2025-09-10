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
            return Center(
            child: Card(
              elevation: 18,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.all(32),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
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
                    ).translate('users_screen.lbl_company'),
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
                    ).translate('users_screen.lbl_role'),
                  ),
                ),
                DataColumn2(
                  size: ColumnSize.S,
                  fixedWidth: 160,
                  label: Text(
                    AppLocalization.of(
                      context,
                    ).translate('users_screen.lbl_actions'),
                   ),
                    ),
                  ],
                  source: UsersRows(),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
