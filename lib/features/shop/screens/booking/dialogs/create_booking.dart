// lib/features/shop/screens/booking/dialogs/create_booking_dialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/booking_timeslot_model.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';

class CreateBookingDialog extends StatelessWidget {
  const CreateBookingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BookingController>(tag: 'company_bookings');
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    // clear any previous values
    c.createCategoryId.value = null;
    c.createObjectId.value = null;
    c.createUserId.value = null;
    c.createUnitId.value = null;
    c.createBookingDate.value = null;
    c.createSlotTime.value = null;
    c.createEndSlotTime.value = null;
    c.createLoading.value = false;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 500),
            child: Column(
              children: <Widget>[
                // ── HEADER ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace,
                    vertical: TSizes.sm,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          AppLocalization.of(
                            context,
                          ).translate('bookings_screen.lbl_new_booking'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // ── MIDDLE ───────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace,
                    ),
                    child: Obx(() {
                      // build end‐slot slice
                      final slots = c.createSlots.toList();
                      final startIdx = slots.indexWhere(
                        (s) => s.slotTime == c.createSlotTime.value,
                      );
                      final nextBookedRel = slots
                          .skip(startIdx + 1)
                          .toList()
                          .indexWhere((s) => s.status == 2);
                      final boundaryIdx =
                          nextBookedRel >= 0
                              ? startIdx + 1 + nextBookedRel
                              : slots.length - 1;
                      final endSlots =
                          (startIdx >= 0 && boundaryIdx >= startIdx + 1)
                              ? slots.sublist(startIdx + 1, boundaryIdx + 1)
                              : <dynamic>[];

                      // ← WRAP HERE IN A FORM
                      return Form(
                        key: c.formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(height: TSizes.spaceBtwSections),

                              // 1) Category
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: AppLocalization.of(
                                    context,
                                  ).translate(
                                    'bookings_screen.lbl_amenity_category',
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    c.createCategories
                                        .map(
                                          (cat) => DropdownMenuItem<int>(
                                            value: cat.id,
                                            child: Text(cat.name),
                                          ),
                                        )
                                        .toList(),
                                value: c.createCategoryId.value,
                                onChanged: c.onCreateCategoryChanged,
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),

                              // 2) Building
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: AppLocalization.of(
                                    context,
                                  ).translate('bookings_screen.lbl_building'),
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    c.objectsList
                                        .map(
                                          (b) => DropdownMenuItem<int>(
                                            value: int.parse(b.id!),
                                            child: Text(b.name!),
                                          ),
                                        )
                                        .toList(),
                                value: c.createObjectId.value,
                                onChanged: c.onCreateObjectChanged,
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),

                              // 3) Tenant
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: AppLocalization.of(
                                    context,
                                  ).translate('bookings_screen.lbl_tenant'),
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    c.createUsers
                                        .map<DropdownMenuItem<int>>(
                                          (t) => DropdownMenuItem<int>(
                                            value: int.parse(t.id!),
                                            child: Text(t.fullName),
                                          ),
                                        )
                                        .toList(),
                                value: c.createUserId.value,
                                onChanged: c.onCreateUserChanged,
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),

                              // 4) Amenity Unit
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: AppLocalization.of(
                                    context,
                                  ).translate(
                                    'bookings_screen.lbl_amenity_unit',
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                items:
                                    c.createUnits
                                        .map(
                                          (u) => DropdownMenuItem<int>(
                                            value: u.id,
                                            child: Text(u.name),
                                          ),
                                        )
                                        .toList(),
                                value: c.createUnitId.value,
                                onChanged: c.onCreateUnitChanged,
                                validator: (v) => v == null ? 'Required' : null,
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),

                              // 5) Date Picker
                              Text(
                                AppLocalization.of(
                                  context,
                                ).translate('bookings_screen.lbl_select_date'),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                focusedDay:
                                    c.createBookingDate.value ?? DateTime.now(),
                                selectedDayPredicate:
                                    (d) =>
                                        isSameDay(c.createBookingDate.value, d),
                                onDaySelected:
                                    (sel, foc) => c.onCreateDateChanged(sel),
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                ),
                                calendarStyle: CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: TColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),

                              // 6) Time Slots
                              c.createSlots.isNotEmpty
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 6a) Start Slots
                                      Text(
                                        AppLocalization.of(context).translate(
                                          'booking_details_screen.lbl_time_slots_starting_time',
                                        ),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: TSizes.sm),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            slots.map((slot) {
                                              final isBooked = slot.status == 2;
                                              final isUnavailable =
                                                  slot.status == 0;
                                              final isSelected =
                                                  c.createSlotTime.value ==
                                                  slot.slotTime;
                                              return ChoiceChip(
                                                label: Text(
                                                  DateFormat.Hm().format(
                                                    DateFormat(
                                                      "HH:mm:ss",
                                                    ).parse(slot.slotTime),
                                                  ),
                                                ),
                                                selected: isSelected,
                                                onSelected: (sel) {
                                                  if (!isBooked &&
                                                      !isUnavailable) {
                                                    c.createSlotTime.value =
                                                        sel
                                                            ? slot.slotTime
                                                            : null;
                                                    c.createEndSlotTime.value =
                                                        null;
                                                  }
                                                },
                                                selectedColor: TColors.primary,
                                                disabledColor:
                                                    const Color.fromARGB(
                                                      255,
                                                      182,
                                                      182,
                                                      182,
                                                    ),
                                                backgroundColor:
                                                    isUnavailable
                                                        ? Colors.grey.shade200
                                                        : null,
                                                labelStyle: TextStyle(
                                                  color:
                                                      isUnavailable
                                                          ? Colors.grey
                                                          : (isBooked
                                                              ? const Color.fromARGB(
                                                                255,
                                                                158,
                                                                158,
                                                                158,
                                                              )
                                                              : (isSelected
                                                                  ? Colors.white
                                                                  : TColors
                                                                      .primary)),
                                                ),
                                              );
                                            }).toList(),
                                      ),

                                      // 6b) End Slots
                                      Obx(() {
                                        final start = c.createSlotTime.value;
                                        if (start == null)
                                          return const SizedBox.shrink();

                                        final slots = c.createSlots;
                                        final startIdx = slots.indexWhere(
                                          (s) => s.slotTime == start,
                                        );
                                        if (startIdx < 0)
                                          return const SizedBox.shrink();

                                        final tail =
                                            slots.skip(startIdx + 1).toList();
                                        final rel = tail.indexWhere(
                                          (s) => s.status != 1,
                                        );

                                        final boundaryIdx =
                                            rel >= 0
                                                ? startIdx + 1 + rel
                                                : slots.length - 1;

                                        final endSlots =
                                            slots
                                                .sublist(
                                                  startIdx + 1,
                                                  boundaryIdx + 1,
                                                )
                                                .map((s) => s.slotTime)
                                                .toList();

                                        if (endSlots.isEmpty)
                                          return const SizedBox.shrink();

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height:
                                                  TSizes.spaceBtwInputFields,
                                            ),
                                            Text(
                                              AppLocalization.of(
                                                context,
                                              ).translate(
                                                "booking_details_screen.lbl_time_slots_ending_time",
                                              ),
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children:
                                                  endSlots.map((slotTime) {
                                                    final tod = DateFormat(
                                                      "HH:mm:ss",
                                                    ).parse(slotTime);
                                                    final label =
                                                        DateFormat.Hm().format(
                                                          tod,
                                                        );
                                                    final isSel =
                                                        c
                                                            .createEndSlotTime
                                                            .value ==
                                                        slotTime;

                                                    return ChoiceChip(
                                                      label: Text(label),
                                                      selected: isSel,
                                                      onSelected: (_) {
                                                        c
                                                            .createEndSlotTime
                                                            .value = isSel
                                                                ? null
                                                                : slotTime;
                                                      },
                                                      selectedColor:
                                                          TColors.primary,
                                                      backgroundColor:
                                                          Colors.white,
                                                      labelStyle: TextStyle(
                                                        color:
                                                            isSel
                                                                ? Colors.white
                                                                : TColors
                                                                    .primary,
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  )
                                  : Center(
                                    child: Text(
                                      AppLocalization.of(context).translate(
                                        "booking_details_screen.msg_no_available_time_slots",
                                      ),
                                    ),
                                  ),

                              const SizedBox(height: TSizes.spaceBtwSections),
                              Row(
                                children: <Widget>[
                                  _legendDot(
                                    TColors.grey,
                                    AppLocalization.of(context).translate(
                                      'booking_details_screen.lbl_not_available',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  _legendDot(
                                    Colors.red,
                                    AppLocalization.of(context).translate(
                                      'booking_details_screen.lbl_booked_slots',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const Divider(height: 1),

                // ── FOOTER ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Obx(() {
                    final canSubmit =
                        c.createCategoryId.value != null &&
                        c.createObjectId.value != null &&
                        c.createUserId.value != null &&
                        c.createUnitId.value != null &&
                        c.createBookingDate.value != null &&
                        c.createSlotTime.value != null &&
                        c.createEndSlotTime.value != null;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            canSubmit
                                ? () async {
                                  await c.submitCreateBooking();
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            c.createLoading.value
                                ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  AppLocalization.of(
                                    context,
                                  ).translate('general_msgs.msg_add'),
                                ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
