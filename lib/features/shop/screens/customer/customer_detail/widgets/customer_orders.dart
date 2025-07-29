import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:xm_frontend/features/shop/screens/customer/customer_detail/table/data_table.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    controller.getCustomerOrders();
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        if (controller.ordersLoading.value) return const TLoaderAnimation();
        if (controller.allCustomerOrders.isEmpty) {
          return const TAnimationLoaderWidget(
            text: 'No Orders Found',
            animation: TImages.tableIllustration,
          );
        }

        final totalAmount = controller.allCustomerOrders.fold(
          0.0,
          (previousValue, element) => previousValue + 1,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orders',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Total Spent '),
                      TextSpan(
                        text: '\$${totalAmount.toString()}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.apply(color: TColors.primary),
                      ),
                      TextSpan(
                        text:
                            ' on ${controller.allCustomerOrders.length} Orders',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchQuery(query),
              decoration: const InputDecoration(
                hintText: 'Search Orders',
                prefixIcon: Icon(Iconsax.search_normal),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            const CustomerOrderTable(),
          ],
        );
      }),
    );
  }
}
