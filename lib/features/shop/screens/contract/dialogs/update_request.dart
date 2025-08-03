import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_rounded_image.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/assign_request_dialog.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/view_request_timeline.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class UpdateRequestDialog extends StatelessWidget {
  const UpdateRequestDialog({
    super.key,
    required this.request,
    required this.tag,
  });

  final RequestModel request;

  final String tag;

  @override
  Widget build(BuildContext context) {
    // final controller = RequestController.instance;

    final controller = Get.find<RequestController>(tag: tag);

    //  controller.selectedStatus.value = request.status!;
    final hasImageUrl =
        request.imageUrl != null && request.imageUrl!.isNotEmpty;

    debugPrint('Hasimage equest dialog: ${hasImageUrl}');

    controller.commentsController.clear();
    controller.selectedStatus.value = 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 700,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${request.requestType} (${request.ticketNumber})',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasImageUrl) ...[
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Center(
                          child: TRoundedImage(
                            width: 250,
                            height: 250,
                            padding: TSizes.sm,

                            // image:
                            //     hasImageUrl
                            //         ? request.imageUrl
                            //         : TImages.defaultImage,
                            // imageType:
                            //     hasImageUrl
                            //         ? ImageType.network
                            //         : ImageType.asset,
                            imageType:
                                request.imageUrl!.isNotEmpty
                                    ? ImageType.network
                                    : ImageType.asset,
                            image:
                                request.imageUrl!.isNotEmpty
                                    ? request.imageUrl!
                                    : TImages.defaultImage,

                            borderRadius: TSizes.borderRadiusMd,
                            backgroundColor: TColors.primaryBackground,
                          ),
                        ),
                      ],

                      const SizedBox(height: TSizes.spaceBtwSections),

                      Row(
                        children: [
                          Text(
                            request.formattedDateTimeWithText,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          TRoundedContainer(
                            radius: TSizes.cardRadiusSm,
                            padding: const EdgeInsets.symmetric(
                              vertical: TSizes.sm,
                              horizontal: TSizes.md,
                            ),
                            backgroundColor: THelperFunctions.getStatusColor(
                              request.status ?? 0,
                            ).withOpacity(0.1),
                            child: Text(
                              THelperFunctions.getStatusText(
                                request.status ?? 0,
                              ),
                              style: TextStyle(
                                color: THelperFunctions.getStatusColor(
                                  request.status ?? 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // description
                      FutureBuilder<String>(
                        future:
                            request
                                .translateDescriptionText(), // Call async function
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              '...', // Placeholder while loading
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              "${request.description}", // Fallback to original if translation fails
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          } else {
                            return Text(
                              "${snapshot.data ?? request.description}", // Use translated text
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // divider
                      const Divider(
                        color: TColors.primaryBackground,
                        thickness: 1.5,
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: TSizes.sm,
                          horizontal: TSizes.md,
                        ),
                        decoration: BoxDecoration(
                          color: TColors.primaryBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity, // Force Row to stretch
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Tenant
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalization.of(
                                      context,
                                    ).translate('users_screen.lbl_user'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.copyWith(
                                      color: TColors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    request.createdByName.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: TSizes.spaceBtwItems),

                            /// Unit
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalization.of(
                                      context,
                                    ).translate('contract_screen.lbl_unit'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.copyWith(
                                      color: TColors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    request.unitNumber.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: TSizes.spaceBtwItems),

                            /// Contract Reference
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalization.of(context).translate(
                                      'edit_building_screen.lbl_contract_reference',
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.copyWith(
                                      color: TColors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    request.contractReference?.isEmpty == true
                                        ? '-'
                                        : request.contractReference ?? '-',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          // **Line Separator before Timeline**
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.5,
                                    indent: 0,
                                    endIndent: 16,
                                  ),
                                ),
                                Text(
                                  AppLocalization.of(
                                    context,
                                  ).translate('general_msgs.msg_new_status'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.5,
                                    indent: 16,
                                    endIndent: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            onChanged:
                                (value) =>
                                    controller.selectedStatus.value = value!,
                            value:
                                null, // Set to null or pre-select based on your logic
                            decoration: InputDecoration(
                              labelText: AppLocalization.of(
                                context,
                              ).translate('edit_contract_screen.lbl_status'),
                              prefixIcon: const Icon(Iconsax.status),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return AppLocalization.of(
                                  context,
                                ).translate('edit_contract_screen.lbl_status');
                              }
                              return null;
                            },
                            items: [
                              if (request.status != 1)
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text(
                                    THelperFunctions.getStatusText(1),
                                  ),
                                ),
                              if (request.status != 2)
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text(
                                    THelperFunctions.getStatusText(2),
                                  ),
                                ),
                              if (request.status != 3)
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text(
                                    THelperFunctions.getStatusText(3),
                                  ),
                                ),
                              if (request.status != 4)
                                DropdownMenuItem(
                                  value: 4,
                                  child: Text(
                                    THelperFunctions.getStatusText(4),
                                  ),
                                ),
                              if (request.status != 5)
                                DropdownMenuItem(
                                  value: 5,
                                  child: Text(
                                    THelperFunctions.getStatusText(5),
                                  ),
                                ),
                              if (request.status != 7)
                                DropdownMenuItem(
                                  value: 7,
                                  child: Text(
                                    THelperFunctions.getStatusText(7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      TextFormField(
                        controller: controller.commentsController,
                        decoration: InputDecoration(
                          labelText: AppLocalization.of(
                            context,
                          ).translate('request_screen.lbl_comment_optional'),
                          prefixIcon: Icon(Iconsax.message),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields * 2),
                    ],
                  ),
                ),
              ),

              /// Actions
              Row(
                children: [
                  Expanded(
                    child:
                    /// Submit Button
                    Obx(() {
                      return controller.loading.value
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.submitRequestUpdate(request);
                              },
                              child: Text(
                                AppLocalization.of(
                                  context,
                                ).translate('general_msgs.msg_update'),
                              ),
                            ),
                          );
                    }),
                  ),

                  const SizedBox(width: TSizes.spaceBtwItems),

                  // Expanded(
                  //   child: TextButton.icon(
                  //     onPressed: () async {
                  //       debugPrint(
                  //         'Request ID from update request: ${request.id}',
                  //       );

                  //       final result = await showDialog<bool>(
                  //         context: context,
                  //         //  barrierDismissible: false,
                  //         builder: (BuildContext context) {
                  //           return AssignRequestDialog(
                  //             requestId: int.parse(request.id.toString()),
                  //             tag: tag,
                  //           );
                  //         },
                  //       );
                  //     },

                  //     icon: const Icon(Iconsax.main_component),
                  //     label: Text(
                  //       AppLocalization.of(context).translate(
                  //         'request_screen.lbl_assign_service_provider',
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        debugPrint(
                          'Request ID from update request: ${request.id}',
                        );

                        final result = await showDialog<bool>(
                          context: context,
                          //  barrierDismissible: false,
                          builder: (BuildContext context) {
                            return ViewRequestTimelineDialog(
                              requestId: int.parse(request.id.toString()),
                              tag: tag,
                            );
                          },
                        );
                      },

                      icon: const Icon(Iconsax.candle),
                      label: Text(
                        AppLocalization.of(
                          context,
                        ).translate('request_screen.lbl_view_timeline'),
                      ),
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
