import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/enums.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';

class CustomerOrdersRows extends DataTableSource {
  final controller = CustomerDetailController.instance;

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredCustomerOrders[index];
    // final totalAmount = order.items.fold<double>(0, (previousValue, element) => previousValue + element.price);
    return DataRow2(
      onTap: () => Get.toNamed(Routes.customers, arguments: ''),
      selected: controller.selectedRows[index],
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
        DataCell(Text(' Items')),
        // DataCell(
        //   TRoundedContainer(
        //     radius: TSizes.cardRadiusSm,
        //     padding: const EdgeInsets.symmetric(
        //       vertical: TSizes.sm,
        //       horizontal: TSizes.md,
        //     ),
        //     backgroundColor: THelperFunctions.getOrderStatusColor(
        //       OrderStatus.delivered,
        //     ).withOpacity(0.1),
        //     child: Text(
        //       ' order.status.name.capitalize.toString()',
        //       style: TextStyle(
        //         color: THelperFunctions.getOrderStatusColor(
        //           OrderStatus.delivered,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        DataCell(Text('300')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCustomerOrders.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
