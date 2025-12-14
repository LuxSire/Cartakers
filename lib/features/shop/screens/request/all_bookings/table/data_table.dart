import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/app_controller.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/features/shop/controllers/request/request_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class RequestsTable extends StatelessWidget {
  const RequestsTable({super.key, required this.isPendingShown});

  final bool isPendingShown;

  @override
  Widget build(BuildContext context) {
    final companyId = AuthenticationRepository.instance.currentUser?.companyId;

    final controller = Get.put(
      RequestController(
        sourceType: RequestSourceType.company,
        id: companyId,
      ),
      tag: 'company_requests',
    );

    final appController = Get.find<AppController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData();
      if (isPendingShown) {
        debugPrint('Showing pending requests');
        controller.applyFilters(1, 0, 0, null, null);

        appController.resetPendingRequestsNavigation();
      }
    });

    return Obx(() {
      // Force Obx update when tenant list or selection changes
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

      return TPaginatedDataTable(
        minWidth: 1100, // Match with BuildingTable or use 700 if more compact
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        onPaginationReset: () => controller.paginatedPage.value = 0,
        columns: [
          DataColumn2(
            fixedWidth: 250,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('users_screen.lbl_user_name'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.createdByName?.toLowerCase() ?? '',
                ),
          ),
          DataColumn2(
            fixedWidth: 180,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('objects_screen.lbl_object_name'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.objectName?.toLowerCase() ?? '',
                ),
          ),

          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('request_screen.lbl_reference'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.ticketNumber?.toLowerCase() ?? '',
                ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(context).translate('request_screen.lbl_type'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.getTranslatedRequestTypeSync(),
                ),
          ),
          DataColumn2(
            size: ColumnSize.L,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('request_screen.lbl_description'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.description!,
                ),
          ),

          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(context).translate('request_screen.lbl_date'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.createdAt!,
                ),
          ),

          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('request_screen.lbl_status'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.status!,
                ),
          ),

          DataColumn2(
            fixedWidth: 150,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('users_screen.lbl_actions'),
            ),
          ),
        ],
        source: RequestsRows(),
      );
    });
  }
}
