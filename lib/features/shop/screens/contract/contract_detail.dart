import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:xm_frontend/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_desktop.dart';
import 'package:xm_frontend/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_mobile.dart';
import 'package:xm_frontend/features/shop/screens/object/unit_detail/responsive_screens/unit_detail_tablet.dart';
import 'package:xm_frontend/features/shop/screens/contract/responsive_screens/contract_detail_desktop.dart';
import 'package:xm_frontend/features/shop/screens/contract/responsive_screens/contract_detail_mobile.dart';
import 'package:xm_frontend/features/shop/screens/contract/responsive_screens/contract_detail_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';

class ContractDetailScreen extends StatelessWidget {
  const ContractDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contract = Get.arguments;

    return contract != null
        ? TSiteTemplate(
          desktop: ContractDetailDesktopScreen(contract: contract),
          tablet: ContractDetailTabletScreen(contract: contract),
          mobile: ContractDetailMobileScreen(contract: contract),
        )
        : const TPageNotFound();
  }
}
