import 'package:flutter/material.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/services/global_notifiers.dart';

class BalanceHeader extends StatelessWidget {
  const BalanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            AppLocalization.of(context).translate('balance_card.title'),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          // Use ValueListenableBuilder to listen to the notifier
          ValueListenableBuilder<double>(
            valueListenable: totalHoursNotifier,
            builder: (context, totalHours, child) {
              return Text(
                totalHours.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
