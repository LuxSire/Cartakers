import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/utils/constants/colors.dart';

enum ViewMode { table, calendar }

class ViewToggleWidget extends StatelessWidget {
  final Rx<ViewMode> currentView;

  const ViewToggleWidget({super.key, required this.currentView});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SegmentedButton<ViewMode>(
        segments: <ButtonSegment<ViewMode>>[
          ButtonSegment(
            value: ViewMode.table,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('general_msgs.msg_week_view'),
            ),
            icon: Icon(Icons.calendar_view_day),
          ),
          ButtonSegment(
            value: ViewMode.calendar,
            label: Text(
              AppLocalization.of(
                context,
              ).translate('general_msgs.msg_month_view'),
            ),
            icon: Icon(Icons.calendar_month),
          ),
        ],
        selected: <ViewMode>{currentView.value},
        onSelectionChanged: (Set<ViewMode> newSelection) {
          if (newSelection.isNotEmpty) {
            currentView.value = newSelection.first;
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.contains(MaterialState.selected)
                    ? TColors.primary.withOpacity(0.1)
                    : Colors.grey.shade100,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) =>
                states.contains(MaterialState.selected)
                    ? TColors.primary
                    : Colors.black87,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      );
    });
  }
}
