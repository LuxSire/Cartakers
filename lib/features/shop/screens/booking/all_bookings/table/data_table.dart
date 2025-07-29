import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_source.dart';

class BookingsTable extends StatelessWidget {
  const BookingsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final agencyId = AuthenticationRepository.instance.currentUser?.agencyId;

    final controller = Get.put(
      BookingController(
        sourceType: BookingSourceType.agency,
        id: int.parse(agencyId!),
      ),
      tag: 'agency_bookings',
    );

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
            fixedWidth: 250,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('bookings_screen.lbl_description'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.title?.toLowerCase() ?? '',
                ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(context).translate('bookings_screen.lbl_date'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.date!,
                ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('bookings_screen.lbl_start_time'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.startTime!,
                ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('bookings_screen.lbl_end_time'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.endTime!,
                ),
          ),
          DataColumn2(
            size: ColumnSize.M,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('bookings_screen.lbl_status'),
            ),
            onSort:
                (columnIndex, ascending) => controller.sortByPropertyName(
                  columnIndex,
                  ascending,
                  (b) => b.status ?? 0,
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
        source: BookingsRows(),
      );
    });
  }
}
