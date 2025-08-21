import 'package:flutter/material.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/responsive_screens/communications_desktop.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/responsive_screens/communications_mobile.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/responsive_screens/communications_tablet.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
// TODO: Update the import path below to the correct location of ObjectModel
import 'package:xm_frontend/data/models/object_model.dart';

class CommunicationScreen extends StatelessWidget { 
  final ObjectModel? object;
  const CommunicationScreen({super.key, this.object});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CommunicationDesktopScreen(object: object),
      tablet: CommunicationTabletScreen(object: object),
      mobile: CommunicationMobileScreen(object: object),
    );
  }
}
