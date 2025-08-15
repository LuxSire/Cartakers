import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/category_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/shop/controllers/booking/booking_controller.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/bookings_filter_dialog.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/create_booking.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_toggle_widget.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class BookingTableHeader extends StatelessWidget {
  const BookingTableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyId = AuthenticationRepository.instance.currentUser?.companyId;
    final controller = Get.put(
      BookingController(
        sourceType: BookingSourceType.company,
        id: companyId!,
      ),
      tag: 'company_bookings',
    );
    final isDesktop = TDeviceUtils.isDesktopScreen(context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Row 1: Create / Refresh / Search / View Toggle / Filters ───
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              // Create & Refresh
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const CreateBookingDialog(),
                      );

                      debugPrint('Create Booking Dialog Result: $result');

                      if (result == true) {
                        debugPrint('Booking created successfully');
                        controller.refreshData();
                        controller.loadData();
                      }
                    },
                    icon: const Icon(
                      Iconsax.add_circle,
                      color: TColors.alterColor,
                    ),
                    label: Text(
                      AppLocalization.of(
                        context,
                      ).translate('bookings_screen.lbl_create_new_booking'),
                      style: const TextStyle(color: TColors.alterColor),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      controller.refreshData();
                      controller.loadData();
                      TLoaders.successSnackBar(
                        title: AppLocalization.of(
                          context,
                        ).translate('general_msgs.msg_info'),
                        message: AppLocalization.of(
                          context,
                        ).translate('general_msgs.msg_data_refreshed'),
                      );
                    },
                    icon: const Icon(
                      Iconsax.refresh,
                      color: TColors.alterColor,
                    ),
                    label: Text(
                      AppLocalization.of(
                        context,
                      ).translate('general_msgs.msg_refresh'),
                      style: const TextStyle(color: TColors.alterColor),
                    ),
                  ),
                ],
              ),

              // Search field
              SizedBox(
                width: isDesktop ? 350 : width - 32,
                child: TextFormField(
                  controller: controller.searchController,
                  onChanged: controller.filterBookings,
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(
                      context,
                    ).translate('bookings_screen.lbl_search_bookings'),
                    prefixIcon: const Icon(Iconsax.search_normal),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),

              // View toggle + Filters
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  //   ViewToggleWidget(currentView: controller.currentView),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const BookingsFilterDialog(),
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

                  // Active filter chips (if any)
                  Obx(() {
                    if (!controller.filtersApplied.value)
                      return const SizedBox.shrink();
                    final active = controller.getActiveFilters();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          active.map((f) {
                            final label = f.keys.first;
                            final onRemove = f.values.first;
                            return Chip(
                              label: Text(label),
                              backgroundColor: TColors.primary.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey.shade100),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: onRemove,
                            );
                          }).toList(),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ─── Row 2: Categories label + chips ───────────────────
        Obx(() {
          final cats = controller.categories;
          if (cats.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${AppLocalization.of(context).translate('bookings_screen.lbl_amenity_categories')}: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          cats.map((cat) {
                            final sel = controller.selectedCategoryIds.contains(
                              cat.id,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text(cat.name),
                                selected: sel,
                                onSelected: (on) {
                                  on
                                      ? controller.selectedCategoryIds.add(
                                        cat.id,
                                      )
                                      : controller.selectedCategoryIds.remove(
                                        cat.id,
                                      );
                                  controller.selectedCategoryIds.refresh();
                                  controller.filterBookings(
                                    controller.searchController.text,
                                  );
                                },
                                selectedColor: TColors.primary.withOpacity(0.2),
                                backgroundColor: Colors.grey.shade100,
                                labelStyle: TextStyle(
                                  color: sel ? TColors.primary : Colors.black87,
                                  fontWeight:
                                      sel ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
