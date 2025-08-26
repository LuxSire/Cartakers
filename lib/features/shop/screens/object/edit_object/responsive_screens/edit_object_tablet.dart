import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/widgets/object_units.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/widgets/edit_object_form.dart';
import '../widgets/object_docs.dart';
import '../widgets/object_pics.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/communications.dart';
import 'package:xm_frontend/features/shop/screens/communication/all_communications/widgets/communication_detail_tab.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditObjectTabletScreen extends StatelessWidget {
  const EditObjectTabletScreen({super.key, required this.object});

  final ObjectModel object;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditObjectController>();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body:   Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs
                TBreadcrumbsWithHeading(
                  onreturnUpdated: () => controller.isDataUpdated.value,
                  returnToPreviousScreen: true,
                  heading: AppLocalization.of(
                    context,
                  ).translate('edit_object_screen.lbl_object_details'),
                  breadcrumbItems: [],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
      // TabBar with 3 tabs
              TabBar(
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Documents'),
                  Tab(text: 'Images'),
                  Tab(text: 'Units'),
                  Tab(text: 'Communications'),
                ],
              ),
            const SizedBox(height: TSizes.spaceBtwSections*2),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: EditObjectForm
                    EditObjectForm(object: object),
                    ObjectDocsWidget(objectId: object.id!), // Tab 2: Documents
                    ObjectPicsWidget(objectId: object.id!), // Tab 3: Images
                    ObjectUnits(object: object), // Tab 4: Units
                    CommunicationDetailsTab(tabType: 'messages',object: object), // Tab 5: Communications
                  ],
                ),
              ),

                //CommunicationScreen(object: object),
                // Units at the bottom, full width
                //ObjectUnits(object: object),
              ],
            ),
          ),
        ),
    );
  }
}
