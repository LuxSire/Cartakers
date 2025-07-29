import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/utils/theme/widget_themes/checkbox_theme.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../loaders/animation_loader.dart';

/// Custom PaginatedDataTable widget with additional features
class TPaginatedDataTable extends StatelessWidget {
  final VoidCallback? onPaginationReset;

  const TPaginatedDataTable({
    super.key,
    this.onPaginationReset,
    required this.columns,
    required this.source,
    this.rowsPerPage = 10,
    this.tableHeight = 760,
    this.onPageChanged,
    this.sortColumnIndex,
    this.dataRowHeight = TSizes.xl * 2,
    this.sortAscending = true,
    this.minWidth = 1000,
  });

  final bool sortAscending;
  final int? sortColumnIndex;
  final int rowsPerPage;
  final DataTableSource source;
  final List<DataColumn> columns;
  final Function(int)? onPageChanged;
  final double dataRowHeight;
  final double tableHeight;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tableHeight,
      child: Theme(
        data: Theme.of(context).copyWith(
          cardTheme: const CardTheme(color: Colors.white, elevation: 0),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(TColors.primary),
            checkColor: MaterialStateProperty.all(Colors.white),
          ),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: TColors.primary,
            secondary: TColors.primary,
            secondaryContainer: TColors.primary,
          ),
        ),
        child: PaginatedDataTable2(
          source: source,
          border: TableBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(TSizes.borderRadiusMd),
            ),
            horizontalInside: BorderSide(
              color: TColors.grey.withOpacity(0.3),
              width: 1,
            ),
            verticalInside: BorderSide(
              color: TColors.grey.withOpacity(0.3),
              width: 1,
            ),
            bottom: BorderSide(color: TColors.grey.withOpacity(0.3), width: 1),
            top: BorderSide(color: TColors.grey.withOpacity(0.3), width: 1),
            right: BorderSide(color: TColors.grey.withOpacity(0.3), width: 1),
            left: BorderSide(color: TColors.grey.withOpacity(0.3), width: 1),
          ),
          columns: columns,
          columnSpacing: 12,
          minWidth: minWidth,
          dividerThickness: 0,
          horizontalMargin: 12,
          rowsPerPage: rowsPerPage,
          dataRowHeight: dataRowHeight,
          showCheckboxColumn: true,
          showFirstLastButtons: true,
          renderEmptyRowsInTheEnd: false,
          onRowsPerPageChanged: (noOfRows) {},
          onPageChanged: (pageIndex) {
            if (onPageChanged != null) onPageChanged!(pageIndex);
            if (pageIndex == 0 && onPaginationReset != null) {
              onPaginationReset!();
            }
          },
          headingTextStyle: Theme.of(context).textTheme.titleMedium,
          headingRowColor: WidgetStateProperty.resolveWith(
            (states) => TColors.secondaryBackground,
          ),
          headingRowDecoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TSizes.borderRadiusMd),
              topRight: Radius.circular(TSizes.borderRadiusMd),
            ),
          ),
          empty: TAnimationLoaderWidget(
            animation: TImages.tableIllustration,
            text: AppLocalization.of(
              context,
            ).translate('general_msgs.msg_no_data_found'),
            height: 200,
            width: 200,
          ),
          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          sortArrowBuilder: (bool ascending, bool sorted) {
            if (sorted) {
              return Icon(
                ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                size: TSizes.iconSm,
              );
            } else {
              return const Icon(Iconsax.arrow_3, size: TSizes.iconSm);
            }
          },
        ),
      ),
    );
  }
}
