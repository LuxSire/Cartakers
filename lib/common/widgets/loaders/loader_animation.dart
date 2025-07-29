import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';

/// A circular loader widget with customizable foreground and background colors.
class TLoaderAnimation extends StatelessWidget {
  const TLoaderAnimation({super.key, this.height = 300, this.width = 300});

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image(
            image: const AssetImage(TImages.buildingsIllustration),
            height: height,
            width: width,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            AppLocalization.of(context).translate('general_msgs.msg_loading'),
          ),
        ],
      ),
    );
  }
}
