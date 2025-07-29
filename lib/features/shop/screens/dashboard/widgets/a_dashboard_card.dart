import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/common/widgets/icons/t_circular_icon.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class ADashboardCard extends StatelessWidget {
  const ADashboardCard({
    super.key,
    required this.context,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.icon = Iconsax.arrow_up_3,
    this.color = TColors.success,
    this.onTap,
    required this.headingIcon,
    required this.headingIconColor,
    required this.headingIconBgColor,
  });

  final BuildContext context;
  final String title, subTitle;
  final IconData icon, headingIcon;
  final Color color, headingIconColor, headingIconBgColor;
  final int stats;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,

      child: TRoundedContainer(
        onTap: onTap,
        padding: const EdgeInsets.all(TSizes.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                TSectionHeading(
                  title: title,
                  textColor: TColors.textSecondary.withOpacity(0.5),
                ),
              ],
            ),
            TCircularIcon(
              icon: headingIcon,
              backgroundColor: headingIconBgColor,
              color: headingIconColor,
              size: TSizes.md,
            ),
          ],
        ),
      ),
    );
  }
}
