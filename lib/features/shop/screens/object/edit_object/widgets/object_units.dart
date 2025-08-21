import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/table/data_table.dart';
import 'package:xm_frontend/features/shop/screens/object/edit_object/table/table_header.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';

class ObjectUnits extends StatefulWidget {
  const ObjectUnits({super.key, required this.object});

  final ObjectModel object;

  @override
  State<ObjectUnits> createState() => _ObjectUnitsState();
}

class _ObjectUnitsState extends State<ObjectUnits> {
  final controller = EditObjectController.instance;

  @override
  void initState() {
    super.initState();
    controller.getObjectUnits(widget.object);
  }



  @override
  Widget build(BuildContext context) {
    //final controller = EditObjectController.instance;

    //controller.getObjectUnits(object);
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        if (controller.unitsLoading.value) return const TLoaderAnimation();
        if (controller.allObjectUnits.isEmpty) {
          return TAnimationLoaderWidget(
            text: AppLocalization.of(
              context,
            ).translate('general_msgs.msg_no_data_found'),
            animation: TImages.tableIllustration,
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
                  ).translate('edit_object_screen.lbl_units'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // Text.rich(
                //   TextSpan(
                //     children: [
                //       const TextSpan(text: 'Total Spent '),
                //       TextSpan(
                //           text: '\$${totalAmount.toString()}',
                //           style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary)),
                //       TextSpan(text: ' on ${controller.allBuildingUnits.length} Orders', style: Theme.of(context).textTheme.bodyLarge),
                //     ],
                //   ),
                // ),
              ],
            ),
            // TextFormField(
            //   controller: controller.searchTextController,
            //   onChanged: (query) => controller.searchQuery(query),
            //   decoration: InputDecoration(
            //     hintText: AppLocalization.of(
            //       context,
            //     ).translate('edit_building_screen.lbl_search_units'),
            //     prefixIcon: Icon(Iconsax.search_normal),
            //   ),
            // ),
            //  Expanded(
            //    child: ObjectUnitsTableHeader(object: object),
            //  ),

            Expanded(
              child:  ObjectUnitTable(),
            ),
          ],
        );
      }),
    );
  }
}
