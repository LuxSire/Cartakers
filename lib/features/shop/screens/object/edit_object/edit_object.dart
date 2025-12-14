import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/features/shop/screens/object/edit_object/responsive_screens/edit_object_desktop.dart';
import 'package:cartakers/features/shop/screens/object/edit_object/responsive_screens/edit_object_mobile.dart';
import 'package:cartakers/features/shop/screens/object/edit_object/responsive_screens/edit_object_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/page_not_found/page_not_found.dart';

class EditObjectScreen extends StatelessWidget {
  const EditObjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final object = Get.arguments;

    return object != null
        ? TSiteTemplate(
          desktop: EditObjectDesktopScreen(object: object),
          tablet: EditObjectTabletScreen(object: object),
          mobile: EditObjectMobileScreen(object: object),
        )
        : const TPageNotFound();
  }
}
