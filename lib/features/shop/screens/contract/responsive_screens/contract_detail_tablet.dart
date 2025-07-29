import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/screens/building/unit_detail/widgets/unit_contracts.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/contract_tab_panel.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/contract_info.dart';

class ContractDetailTabletScreen extends StatelessWidget {
  const ContractDetailTabletScreen({super.key, required this.contract});

  final ContractModel contract;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController());

    controller.initializeContractData(int.parse(contract.id!));

    // Set the unit into controller (only once when screen builds)
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.contractModel.value = contract;
    //   debugPrint(
    //     'Contract detail: ${controller.contractModel.value.tenants!.length}',
    //   );
    // });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                onreturnUpdated: () => controller.isDataUpdated.value,

                returnToPreviousScreen: true,
                heading: contract.contractCode!,
                breadcrumbItems: const [
                  // Routes.buildingsUnits,
                  // 'Building Unit Details',
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Contract Info
                        const ContractInfo(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Contract Details Tabs
                        const ContractTabPanel(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
