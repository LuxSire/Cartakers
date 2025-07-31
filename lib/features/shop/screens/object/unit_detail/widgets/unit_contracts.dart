import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/object/unit_detail/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/object/unit_detail/widgets/table_header.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class UnitContracts extends StatelessWidget {
  const UnitContracts({super.key, required this.unit});

  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    final controller = ObjectUnitDetailController.instance;

    controller.getUsersOfCurrentUnit;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        if (controller.contractsLoading.value) return const TLoaderAnimation();
        if (controller.allObjectUnitContracts.isEmpty) {
          return Column(
            children: [
              TAnimationLoaderWidget(
                text: AppLocalization.of(
                  context,
                ).translate('general_msgs.msg_no_data_found'),
                animation: TImages.tableIllustration,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextButton.icon(
                onPressed: () async {
                  final newContract = await showDialog<ContractModel>(
                    context: Get.context!,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CreateContractDialog(
                        displayUnits: false,
                        objectId: unit.objectId!,
                      );
                    },
                  );

                  if (newContract != null) {
                    // reload the list of contracts
                    controller.getUsersOfCurrentUnit();
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('unit_detail_screen.lbl_create_new_contract'),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalization.of(
                    context,
                  ).translate('unit_detail_screen.lbl_contracts'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            ObjectUnitContractTableHeader(),
            const SizedBox(height: TSizes.spaceBtwSections),
            const ObjectUnitContractTable(),
          ],
        );
      }),
    );
  }
}
