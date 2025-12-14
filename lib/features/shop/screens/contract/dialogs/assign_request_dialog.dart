import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/api/translation_api.dart';
import 'package:cartakers/features/shop/controllers/request/request_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class AssignRequestDialog extends StatelessWidget {
  const AssignRequestDialog({super.key, this.requestId,  this.tag});

  final int? requestId;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<RequestController>();

    final controller = Get.find<RequestController>(tag: tag);

    controller.loadAllMaintenanceServicers();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 400,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalization.of(
                    context,
                  ).translate('request_screen.lbl_service_provider'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Obx(() {
              return DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,

                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedServicerId.value = value;
                      }
                    },
                    validator: (value) {
                      if (value == null || value == 0) {
                        return AppLocalization.of(context).translate(
                          'request_screen.lbl_select_service_provider',
                        );
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalization.of(
                        context,
                      ).translate('request_screen.lbl_service_provider'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text(
                          AppLocalization.of(context).translate(
                            "request_screen.lbl_select_service_provider",
                          ),
                        ),
                      ),
                      ...controller.maintenanceServicersList.map(
                        (servicer) => DropdownMenuItem<int>(
                          value: int.parse(servicer.id!),
                          child: Text(servicer.name!),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.commentsServicerController,
              decoration: InputDecoration(
                labelText: AppLocalization.of(
                  context,
                ).translate('request_screen.lbl_comment_optional'),
                prefixIcon: Icon(Iconsax.message),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(() {
              return controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.submitRequestAssign();
                      },
                      child: Text(
                        AppLocalization.of(
                          context,
                        ).translate('request_screen.lbl_assign'),
                      ),
                    ),
                  );
            }),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
