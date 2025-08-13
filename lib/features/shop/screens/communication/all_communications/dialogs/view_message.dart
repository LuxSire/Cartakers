import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_rounded_image.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/data/models/message_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/view_request_timeline.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class ViewMessageDialog extends StatelessWidget {
  const ViewMessageDialog({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunicationController>();

    // final hasImageUrl =
    //    request.imageUrl != null && request.imageUrl!.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 600,
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
                    message.title ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (hasImageUrl) ...[
                      //   const SizedBox(height: TSizes.spaceBtwSections),
                      //   Center(
                      //     child: TRoundedImage(
                      //       width: 250,
                      //       height: 250,
                      //       padding: TSizes.sm,

                      //       imageType:
                      //           request.imageUrl!.isNotEmpty
                      //               ? ImageType.network
                      //               : ImageType.asset,
                      //       image:
                      //           request.imageUrl!.isNotEmpty
                      //               ? request.imageUrl!
                      //               : TImages.defaultImage,

                      //       borderRadius: TSizes.borderRadiusMd,
                      //       backgroundColor: TColors.primaryBackground,
                      //     ),
                      //   ),
                      // ],

                      // const SizedBox(height: TSizes.spaceBtwSections),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                message.scheduledAt != null
                                    ? Icons.schedule
                                    : Icons.send,
                                size: 16,
                                color:
                                    message.scheduledAt != null
                                        ? Colors.blueAccent
                                        : Colors.green,
                              ),
                              const SizedBox(width: 6),
                              Tooltip(
                                message:
                                    message.scheduledAt != null
                                        ? AppLocalization.of(
                                          Get.context!,
                                        ).translate(
                                          'general_msgs.msg_scheduled_message',
                                        )
                                        : AppLocalization.of(
                                          Get.context!,
                                        ).translate(
                                          'general_msgs.msg_sent_immediately',
                                        ),
                                child: Text(
                                  message.scheduledAt != null
                                      ? TFormatter.formatDateTimeWithText(
                                        message.scheduledAt!,
                                      )
                                      : TFormatter.formatDateTimeWithText(
                                        message.createdAt!,
                                      ),
                                ),
                              ),

                              const SizedBox(width: TSizes.spaceBtwItems),
                              Wrap(
                                spacing: TSizes.xs,
                                children:
                                    message.channels.map((channel) {
                                      return Chip(
                                        label: Text(channel),
                                        backgroundColor:
                                            THelperFunctions.getChannelColor(
                                              channel,
                                            ),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: THelperFunctions.getMessageStatusColor(
                                message.statusName ?? '',
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              THelperFunctions.getMessageStatusText(
                                message.statusId!,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // description
                      Text(
                        message.content ?? '', // Use translated text
                        style: Theme.of(context).textTheme.bodyMedium,
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalization.of(context).translate(
                                      'communication_screen.lbl_recipients',
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.copyWith(
                                      color: TColors.black.withOpacity(0.5),
                                    ),
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        message.recipients.map((recipient) {
                                          return Text(
                                            recipient.recipientLabel ??
                                                '${recipient.recipientType} #${recipient.recipientId}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge,
                                          );
                                        }).toList(),
                                  ),
                                ],
                              ),
                            ),

                            //  SizedBox(width: TSizes.spaceBtwItems),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Actions
              Row(
                children: [
                  // Expanded(
                  //   child:
                  //   /// Submit Button
                  //   Obx(() {
                  //     return controller.loading.value
                  //         ? const Center(child: CircularProgressIndicator())
                  //         : SizedBox(
                  //           width: double.infinity,
                  //           child: ElevatedButton(
                  //             onPressed: () {
                  //               //   controller.submitRequestUpdate(request);
                  //             },
                  //             child: Text(
                  //               AppLocalization.of(
                  //                 context,
                  //               ).translate('general_msgs.msg_update'),
                  //             ),
                  //           ),
                  //         );
                  //   }),
                  // ),

                  // const SizedBox(width: TSizes.spaceBtwItems),

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
                  //           return ViewRequestTimelineDialog(
                  //             requestId: int.parse(request.id.toString()),
                  //             tag: tag,
                  //           );
                  //         },
                  //       );
                  //     },

                  //     icon: const Icon(Iconsax.candle),
                  //     label: Text(
                  //       AppLocalization.of(
                  //         context,
                  //       ).translate('request_screen.lbl_view_timeline'),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
