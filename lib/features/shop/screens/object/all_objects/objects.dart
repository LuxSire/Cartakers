import 'package:flutter/material.dart';
import 'package:cartakers/features/shop/screens/object/all_objects/responsive_screens/objects_desktop.dart';
import 'package:cartakers/features/shop/screens/object/all_objects/responsive_screens/objects_mobile.dart';
import 'package:cartakers/features/shop/screens/object/all_objects/responsive_screens/objects_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class ObjectsScreen extends StatelessWidget {
  const ObjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: ObjectsDesktopScreen(),
      tablet: ObjectsTabletScreen(),
      mobile: ObjectsMobileScreen(),
    );
  }
}
