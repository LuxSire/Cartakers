import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/contract_detail_tab.dart';
import 'package:xm_frontend/features/shop/screens/contract/widgets/contract_tab_panel.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/contract_info.dart';

class PermissionDetailDesktopScreen extends StatelessWidget {
  const PermissionDetailDesktopScreen({super.key, required this.contract});

  final PermissionModel contract;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());

    controller.initializeContractData(int.parse(contract.id!));

    // // Set the unit into controller (only once when screen builds)
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.contractModel.value = contract;
    //   debugPrint(
    //     'Contract detail: ${controller.contractModel.value.tenants!.length}',
    //   );
    // });

    // this will be used at later stage to load requests related to this contract
    Get.put(
      RequestController(
        sourceType: RequestSourceType.contract,
        id: int.parse(contract.id!),
      ),
      tag: 'contract_requests',
    );

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
                heading: contract.permissionId.toString() ?? '',
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
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        // Contract Info
                        const ContractInfo(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Contract Details Tabs
                        //const ContractTabPanel(),
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
