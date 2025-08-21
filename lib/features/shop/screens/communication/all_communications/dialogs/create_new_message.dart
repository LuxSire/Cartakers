import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/features/shop/controllers/communication/communication_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';

class CreateMessageDialog extends StatelessWidget {
  const CreateMessageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CommunicationController.instance;
    controller.clearMessageForm();
    controller.selectObject(-1);
    controller.toggleChannel('push'); // Default to push notification

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 12,
      child: SizedBox(
        width: 900,
        height: 540,
        child: Row(
          children: [
            // LEFT PANEL
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalization.of(
                            context,
                          ).translate('communication_screen.lbl_new_message'),
                          style: Get.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.md),
                  // Building selector
                  Obx(() {
                    return DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<int>(
                          value: controller.selectedObjectId.value,
                          isExpanded: true,
                          onChanged: (v) => controller.selectObject(v ?? -1),
                          decoration: InputDecoration(
                            labelText: AppLocalization.of(context).translate(
                              'communication_screen.lbl_select_object',
                            ),
                            filled: true,
                            fillColor: TColors.grey.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: -1,
                              child: Text(
                                AppLocalization.of(context).translate(
                                  'communication_screen.lbl_all_objects',
                                ),
                              ),
                            ),
                            ...controller.objectsList.map(
                              (b) => DropdownMenuItem(
                                value: b.id!,
                                child: Text(b.name ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: TSizes.md),
                  Obx(
                    () => Text(
                      '${AppLocalization.of(context).translate('communication_screen.lbl_recipients')}: ${controller.totalRecipients}',
                      style: Get.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // RIGHT PANEL
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title field
                        TextFormField(
                          controller: controller.titleController,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(
                              context,
                            ).translate('communication_screen.lbl_enter_title'),
                            prefixIcon: const Icon(Icons.subject_outlined),
                            filled: true,
                            fillColor: TColors.grey.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator:
                              (v) =>
                                  v?.isEmpty == true
                                      ? AppLocalization.of(context).translate(
                                        'communication_screen.lbl_required',
                                      )
                                      : null,
                        ),
                        const SizedBox(height: TSizes.md),
                        // Body field
                        Expanded(
                          child: TextFormField(
                            controller: controller.contentController,
                            expands: true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: AppLocalization.of(context).translate(
                                'communication_screen.lbl_type_your_message',
                              ),
                              alignLabelWithHint: true,

                              // Use `prefix` instead of `prefixIcon` — prefix sits at the
                              // start of the field on the same baseline as the hint.
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.message_outlined,
                                  size: 20,
                                  color: TColors.darkGrey,
                                ),
                              ),

                              // Now remove the automatic prefixIcon padding and tune content padding:
                              prefixIconConstraints: const BoxConstraints(),
                              filled: true,
                              fillColor: TColors.grey.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            validator:
                                (v) =>
                                    v?.isEmpty == true
                                        ? AppLocalization.of(context).translate(
                                          'communication_screen.lbl_required',
                                        )
                                        : null,
                          ),
                        ),

                        const SizedBox(height: TSizes.md),
                        // Channels & Schedule
                        Row(
                          children: [
                            Obx(
                              () => Wrap(
                                spacing: TSizes.sm,
                                children:
                                    controller.availableChannels.map((ch) {
                                      final isSelected = controller
                                          .selectedChannels
                                          .contains(ch);
                                      return ChoiceChip(
                                        label: Text(
                                          ch == 'push'
                                              ? AppLocalization.of(context)
                                                  .translate(
                                                    'communication_screen.lbl_push_notification',
                                                  )
                                                  .toUpperCase()
                                              : ch.toUpperCase(),
                                          style:
                                              isSelected
                                                  ? Get.textTheme.bodyMedium
                                                      ?.copyWith(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255,
                                                            ),
                                                      )
                                                  : Get.textTheme.bodyMedium,
                                        ),
                                        selected: isSelected,
                                        onSelected:
                                            (_) => controller.toggleChannel(ch),
                                        backgroundColor: TColors.grey
                                            .withOpacity(0.3),
                                        selectedColor: TColors.primary,
                                        checkmarkColor: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        elevation: 2,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          side: BorderSide(
                                            color:
                                                isSelected
                                                    ? TColors.primary
                                                    : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),

                            const Spacer(),
                            Obx(
                              () => Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: controller.scheduleNow.value,
                                    activeColor: TColors.primary, // ← here
                                    onChanged:
                                        (v) =>
                                            controller.scheduleNow.value = v!,
                                  ),
                                  Text(
                                    AppLocalization.of(
                                      context,
                                    ).translate('communication_screen.lbl_now'),
                                  ),
                                  const SizedBox(width: TSizes.sm),
                                  Radio<bool>(
                                    value: true,
                                    groupValue: controller.scheduleNow.value,
                                    activeColor: TColors.primary, // ← here
                                    onChanged:
                                        (v) =>
                                            controller.scheduleNow.value = v!,
                                  ),
                                  Text(
                                    AppLocalization.of(context).translate(
                                      'communication_screen.lbl_schedule',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // DateTime Picker
                        Obx(
                          () =>
                              controller.scheduleNow.value
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: TSizes.sm,
                                    ),
                                    child: TextFormField(
                                      controller: controller.scheduleController,
                                      readOnly: true,
                                      onTap:
                                          () => controller.pickScheduleDate(
                                            context,
                                          ),
                                      decoration: InputDecoration(
                                        hintText: AppLocalization.of(
                                          context,
                                        ).translate(
                                          'communication_screen.lbl_select_date_time',
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.schedule_outlined,
                                        ),
                                        filled: true,
                                        fillColor: TColors.grey.withOpacity(
                                          0.1,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  )
                                  : const SizedBox(),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        // Send Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width:
                                AppLocalization.of(context)
                                    .translate(
                                      'communication_screen.lbl_send_message',
                                    )
                                    .length *
                                10.0,
                            child: ElevatedButton(
                              onPressed: () => controller.submitNewMessage(),
                              //  onPressed: () {},
                              child: Text(
                                AppLocalization.of(context).translate(
                                  'communication_screen.lbl_send_message',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
