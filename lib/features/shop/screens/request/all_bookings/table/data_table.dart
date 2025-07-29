import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/app_controller.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class RequestsTable extends StatelessWidget {
  const RequestsTable({super.key, required this.isPendingShown});

  final bool isPendingShown;

  @override
  Widget build(BuildContext context) {
    final agencyId = AuthenticationRepository.instance.currentUser?.agencyId;

    final controller = Get.put(
      RequestController(
        sourceType: RequestSourceType.agency,
        id: int.parse(agencyId!),
      ),
      tag: 'agency_requests',
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
              ).translate('tenants_screen.lbl_tenant_name'),
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
              ).translate('buildings_screen.lbl_building_name'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.buildingName?.toLowerCase() ?? '',
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
              ).translate('tenants_screen.lbl_actions'),
            ),
          ),
        ],
        source: RequestsRows(),
      );
    });
  }
}
