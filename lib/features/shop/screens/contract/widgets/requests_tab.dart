import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/image_uploader.dart';
import 'package:xm_frontend/common/widgets/images/t_rounded_image.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/bookings_filter_dialog.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/requests_filter_dialog.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/update_request.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerContract = Get.find<PermissionController>();

    final controller = Get.find<RequestController>(tag: 'contract_requests');

    // Load data once during initialization

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData();
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total bookings text
              Obx((() {
                return Text(
                  '${controller.totalRequests.value} ${AppLocalization.of(context).translate('bookings_and_requests_screen.lbl_requests')}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              })),
              Row(
                children: [
                  // Sort button placeholder
                  // IconButton(
                  //   icon: const Icon(Icons.sort),
                  //   onPressed: () {
                  //     // Implement sorting logic here
                  //   },
                  // ),
                  // Filter button
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const RequestsFilterDialog(),
                      );
                    },
                    icon: const Icon(Icons.filter_list, size: 20),
                    label: Text(
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_filters'),
                      style: TextStyle(color: TColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Bookings list
          Expanded(
            child: Obx(() {
              if (controller.filteredRequests.isEmpty) {
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                      child: TAnimationLoaderWidget(
                        height: 250,
                        text: AppLocalization.of(
                          context,
                        ).translate('general_msgs.msg_no_data_found'),
                        animation: TImages.noDataIllustration,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredRequests.length,
                itemBuilder: (context, index) {
                  return _buildRequestCard(
                    controller.filteredRequests[index],
                    controller,
                    context,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    RequestModel request,
    RequestController controller,
    BuildContext context,
  ) {
    //final dateAndStartEndTime = "$date, $startTime - $endTime";
    final hasImageUrl =
        request.imageUrl != null && request.imageUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(
        bottom: 16.0,
      ), // Added bottom margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                TRoundedImage(
                  padding: TSizes.sm,
                  image: hasImageUrl ? request.imageUrl : TImages.defaultImage,
                  imageType: hasImageUrl ? ImageType.network : ImageType.asset,
                  borderRadius: TSizes.borderRadiusMd,
                  backgroundColor: TColors.primaryBackground,
                ),
                const SizedBox(width: 16),

                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${request.requestType} (${request.ticketNumber})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.formattedDateTimeWithText,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),

                      FutureBuilder<String>(
                        future: request.translateDescriptionText(),
                        builder: (context, snapshot) {
                          final description =
                              snapshot.hasData
                                  ? snapshot.data
                                  : request.description;

                          return Text(
                            description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          );
                        },
                      ),

                      if (TDeviceUtils.isMobileScreen(context)) ...[
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Row(
                          children: [
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
                            const SizedBox(width: TSizes.spaceBtwItems),
                            IconButton(
                              icon: const Icon(Iconsax.edit),
                              onPressed: () async {
                                final updatedRequest =
                                    await showDialog<RequestModel>(
                                      context: Get.context!,
                                      barrierDismissible: false,
                                      builder:
                                          (_) => UpdateRequestDialog(
                                            request: request,
                                            tag: 'contract_requests',
                                          ),
                                    );

                                if (updatedRequest != null) {
                                  final index = controller.filteredRequests
                                      .indexWhere((r) => r.id == request.id);
                                  if (index != -1) {
                                    controller.filteredRequests[index] =
                                        updatedRequest;
                                    controller.filteredRequests.refresh();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Desktop-specific trailing actions
                if (!TDeviceUtils.isMobileScreen(context)) ...[
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Row(
                    children: [
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
                          THelperFunctions.getStatusText(request.status ?? 0),
                          style: TextStyle(
                            color: THelperFunctions.getStatusColor(
                              request.status ?? 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      IconButton(
                        icon: const Icon(Iconsax.edit),
                        onPressed: () async {
                          final updatedRequest = await showDialog<RequestModel>(
                            context: Get.context!,
                            barrierDismissible: false,
                            builder:
                                (_) => UpdateRequestDialog(
                                  request: request,
                                  tag: 'contract_requests',
                                ),
                          );

                          if (updatedRequest != null) {
                            final index = controller.filteredRequests
                                .indexWhere((r) => r.id == request.id);
                            if (index != -1) {
                              controller.filteredRequests[index] =
                                  updatedRequest;
                              controller.filteredRequests.refresh();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
