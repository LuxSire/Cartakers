import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/enums.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class OrderRows extends DataTableSource {
  // final controller = OrderController.instance;

  @override
  DataRow? getRow(int index) {
    //  final order = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(Routes.customers, arguments: 'order'),
      selected: false,
      // onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Text(
            'order.id',
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text('order.formattedOrderDate')),
        // DataCell(Text(' Items')),
        // DataCell(
        //   TRoundedContainer(
        //     radius: TSizes.cardRadiusSm,
        //     padding: const EdgeInsets.symmetric(
        //       vertical: TSizes.xs,
        //       horizontal: TSizes.md,
        //     ),
        //     backgroundColor: THelperFunctions.getOrderStatusColor(
        //       OrderStatus.delivered,
        //     ).withOpacity(0.1),
        //     child: Text(
        //       'ss',
        //       style: TextStyle(
        //         color: THelperFunctions.getOrderStatusColor(
        //           OrderStatus.delivered,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        DataCell(Text('0')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 0;

  @override
  int get selectedRowCount => 0;
}
