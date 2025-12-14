import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import '../../../utils/constants/colors.dart';

class TTableActionButtons extends StatelessWidget {
  /// Widget for displaying action buttons for table rows
  const TTableActionButtons({
    super.key,
    this.view = false,
    this.edit = true,
    this.delete = true,
    this.terminateContract = false,
    this.confirmBooking = false,
    this.rejectBooking = false,
    this.sendUserInvitation = false,
    this.onViewPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.onTerminateContractPressed,
    this.onConfirmBookingPressed,
    this.onRejectBookingPressed,
    this.onSendUserInvitationPressed,
  });

  /// Flag to determine whether the view button is enabled
  final bool view;

  /// Flag to determine whether the edit button is enabled
  final bool edit;

  /// Flag to determine whether the delete button is enabled
  final bool delete;

  // Flag to terminate contract is is included in table
  final bool terminateContract;

  final bool sendUserInvitation;

  final bool confirmBooking;
  final bool rejectBooking;

  /// Callback function for when the view button is pressed
  final VoidCallback? onViewPressed;

  /// Callback function for when the edit button is pressed
  final VoidCallback? onEditPressed;

  /// Callback function for when the delete button is pressed
  final VoidCallback? onDeletePressed;

  /// Callback function for when the terminate contract button is pressed
  final VoidCallback? onTerminateContractPressed;

  /// Callback function for when the confirm booking button is pressed
  final VoidCallback? onConfirmBookingPressed;

  /// Callback function for when the reject booking button is pressed
  final VoidCallback? onRejectBookingPressed;

  /// Callback function for when the send user invitation button is pressed
  final VoidCallback? onSendUserInvitationPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (view)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_view'),
            onPressed: onViewPressed,
            icon: const Icon(Iconsax.eye, color: TColors.primary),
          ),
        if (edit)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_edit'),
            onPressed: onEditPressed,
            icon: const Icon(Iconsax.pen_add, color: TColors.primary),
          ),

        if (terminateContract)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_terminate_contract'),

            onPressed: onTerminateContractPressed,
            icon: const Icon(Icons.cancel_outlined, color: Colors.orange),
          ),

        if (confirmBooking)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_confirm_booking'),
            onPressed: onConfirmBookingPressed,
            icon: const Icon(Iconsax.tick_circle, color: Colors.green),
          ),
        if (rejectBooking)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_reject_booking'),
            onPressed: onRejectBookingPressed,
            icon: const Icon(Iconsax.close_circle, color: Colors.red),
          ),

        if (sendUserInvitation)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_send_user_invitation'),
            onPressed: onSendUserInvitationPressed,
            icon: const Icon(Iconsax.send_1, color: TColors.primary),
          ),

        if (delete)
          IconButton(
            tooltip: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_delete'),
            onPressed: onDeletePressed,
            icon: const Icon(Iconsax.trash, color: TColors.error),
          ),
      ],
    );
  }
}
