import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_controller.dart';
import 'package:xm_frontend/features/shop/controllers/object/object_unit_detail_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class UnitInfo extends StatelessWidget {
  const UnitInfo({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ObjectUnitDetailController>();
    final editobjectcontroller=Get.find<EditObjectController>();

   

    return Obx(() {
      //final unit = controller.unit.value;
      final unit = controller.unit.value;
      debugPrint('UnitInfo build called with unit: ${unit.unitNumber}');
      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalization.of(
                context,
              ).translate('edit_object_screen.lbl_unit_information'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_object_screen.lbl_updated_on'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        unit.formattedDate,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_object_screen.lbl_floor'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        '${unit.floorNumber}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_object_screen.lbl_sqm'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
                     Builder(
  builder: (context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editobjectcontroller.unitsqm.text != (unit.sqm?.toString() ?? '')) {
        editobjectcontroller.unitsqm.text = unit.sqm?.toString() ?? '';
      }
    });
    return TextFormField(
      controller: editobjectcontroller.unitsqm,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '-',
        border: const OutlineInputBorder(),
      ),
    );
  },
),
                    ],
                  ),
                ),
                const SizedBox(width: 24), // <--- separation
                Expanded(
                  flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.of(
                          context,
                        ).translate('edit_object_screen.lbl_status'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black.withOpacity(0.5),
                        ),
                      ),
GestureDetector(
  onTap: () {
    // Toggle between 1 and 2
    final newStatus = (unit.statusId == 1) ? 2 : 1;
    unit.statusId = newStatus;
    // Optionally, trigger a UI update if needed
    controller.unit.refresh();
  },
  child: TRoundedContainer(
    radius: TSizes.cardRadiusSm,
    padding: const EdgeInsets.symmetric(
      vertical: TSizes.sm,
      horizontal: TSizes.md,
    ),
    backgroundColor: THelperFunctions.getUnitStatusColor(
      unit.statusId ?? 0,
    ).withOpacity(0.1),
    child: Text(
      THelperFunctions.getUnitStatusText(
        unit.statusId ?? 0,
      ),
      style: TextStyle(
        color: THelperFunctions.getUnitStatusColor(
          unit.statusId ?? 0,
        ),
      ),
    ),
  ),
),
                    ],
                  ),
                ),
              ],
            ),
Padding(
  padding: const EdgeInsets.only(top: TSizes.spaceBtwSections),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppLocalization.of(context).translate(
          'edit_object_screen.lbl_description',
        ),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: TColors.black.withOpacity(0.5),
        ),
      ),
      const SizedBox(height: 8),
       Builder(
        builder: (context) {
          // This ensures the controller is updated when the unit changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (editobjectcontroller.unitdescription.text != (unit.description ?? '')) {
              editobjectcontroller.unitdescription.text = unit.description ?? '';
            }
          });
          return TextFormField(
            controller: editobjectcontroller.unitdescription,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '-',
              border: const OutlineInputBorder(),
            ),
          );
        },
      ),
      
      const SizedBox(height: 12),
      ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: Text(AppLocalization.of(context).translate('edit_object_screen.lbl_update')),
        onPressed: () async {
          // Make sure the controller's text is used for update
          unit.description = editobjectcontroller.unitdescription.text;
          unit.sqm = int.tryParse(editobjectcontroller.unitsqm.text); // or int.tryParse if it's int

          final success = await editobjectcontroller.updateUnitDetails(unit);
          if (success) {
            Get.back(result: true);
          } else {
          // Optionally show an error message
          Get.snackbar('Error', 'Failed to update unit');
          }
        },
      ),
              ],
            ),
          ),
        ], 
            ),
        
      );
    });
  }
}
