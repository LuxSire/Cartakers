import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/containers/rounded_container.dart';
import 'package:cartakers/common/widgets/images/t_circular_image.dart';
import 'package:cartakers/features/personalization/models/user_model.dart';
import 'package:cartakers/features/shop/controllers/booking/booking_controller.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/features/shop/controllers/object/edit_object_controller.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
//import 'package:cartakers/features/shop/controllers/user/user_controller.dart';
//import 'package:cartakers/features/shop/screens/user/dialogs/dep_edit_user.dart';
import 'package:cartakers/routes/routes.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class BookingsRows extends DataTableSource {
  final controller = Get.find<BookingController>(tag: 'company_bookings');

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length)
      return null; // prevent overflow

    final booking = controller.filteredItems[index];
    return DataRow2(
      onTap: () async {},
      //  selected: controller.selectedRows[index],
      //    onSelectChanged:
      //      (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TCircularImage(
                width: 30,
                height: 30,
                padding: 2,
                fit: BoxFit.cover,
                backgroundColor: TColors.primaryBackground,
                image:
                    booking.createdByUserProfileImageUrl!.isNotEmpty
                        ? booking.createdByUserProfileImageUrl
                        : TImages.user,
                imageType:
                    booking.createdByUserProfileImageUrl!.isNotEmpty
                        ? ImageType.network
                        : ImageType.asset,
              ),

              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      booking.createdByName ?? '',

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(booking.objectName!)),
        DataCell(Text(booking.title ?? '')),
        DataCell(Text(booking.formattedDateWithText)),
        DataCell(Text(booking.startTime!.substring(0, 5))),
        DataCell(Text(booking.endTime!.substring(0, 5))),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getStatusColor(
              booking.status!,
            ).withOpacity(0.1),
            child: Text(
              THelperFunctions.getStatusText(booking.status!),
              style: TextStyle(
                color: THelperFunctions.getStatusColor(booking.status!),
              ),
            ),
          ),
        ),

        DataCell(
          booking.status == 1
              ? TTableActionButtons(
                view: booking.status != 1,
                edit: false,
                confirmBooking: booking.status == 1, // pending
                rejectBooking: booking.status == 1, // pending
                onConfirmBookingPressed: () {
                  //await controller.confirmBooking(booking);

                  Get.defaultDialog(
                    title: AppLocalization.of(
                      Get.context!,
                    ).translate('general_msgs.msg_confirm_booking'),
                    content: Text(
                      '${AppLocalization.of(Get.context!).translate('general_msgs.msg_question_confirm_booking')} "${booking.title ?? ''}"',
                    ),
                    confirm: SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        //  onPressed: () async => await deleteOnConfirm(item),
                        onPressed: () async {
                          Get.back();
                          final result = await controller.updateBookingStatus(
                            booking,
                            7,
                          ); // confirmed
                          if (result) {
                            // update the booking status in the list
                            booking.status = 7; // cancelled
                            notifyListeners();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.buttonHeight / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius * 5,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_yes'),
                        ),
                      ),
                    ),
                    cancel: SizedBox(
                      width: 80,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.buttonHeight / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius * 5,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_cancel'),
                        ),
                      ),
                    ),
                  );
                },
                onRejectBookingPressed: () {
                  Get.defaultDialog(
                    title: AppLocalization.of(
                      Get.context!,
                    ).translate('general_msgs.msg_reject_booking'),
                    content: Text(
                      '${AppLocalization.of(Get.context!).translate('general_msgs.msg_question_reject_booking')} "${booking.title ?? ''}"',
                    ),
                    confirm: SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        //  onPressed: () async => await deleteOnConfirm(item),
                        onPressed: () async {
                          Get.back(); // close the dialog
                          final result = await controller.updateBookingStatus(
                            booking,
                            5,
                          ); // cancelled
                          if (result) {
                            // update the booking status in the list
                            booking.status = 5; // cancelled
                            notifyListeners();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.buttonHeight / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius * 5,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_yes'),
                        ),
                      ),
                    ),
                    cancel: SizedBox(
                      width: 80,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.buttonHeight / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius * 5,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_cancel'),
                        ),
                      ),
                    ),
                  );
                },

                onViewPressed: () {},

                delete: false,
                // onDeletePressed: () => controller.confirmAndDeleteItem(booking),
              )
              : Tooltip(
                message: AppLocalization.of(
                  Get.context!,
                ).translate('general_msgs.msg_no_actions_available'),
                child: Icon(Icons.block, color: Colors.grey.shade300, size: 20),
              ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
