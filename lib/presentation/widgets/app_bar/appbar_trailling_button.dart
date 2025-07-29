import 'package:flutter/material.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/app/utils/image_constants.dart';
import 'package:xm_frontend/presentation/widgets/custom_button_style.dart';
import 'package:xm_frontend/presentation/widgets/custom_elevated_button_two.dart';
import 'package:xm_frontend/presentation/widgets/custom_image_view.dart';
import 'package:xm_frontend/presentation/widgets/custom_text_style.dart';

class AppbarTrailingButton extends StatelessWidget {
  const AppbarTrailingButton({super.key, this.onTap, this.margin});

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomElevatedButtonTwo(
          height: 36.0,
          width: 128.0,
          text: AppLocalization.of(context).translate('app_bar.lbl_create'),
          leftIcon: Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: CustomImageView(
              imagePath: ImageConstant.imgHugeiconInterfaceSolidAddcircle,
              height: 24.0,
              width: 24.0,
              fit: BoxFit.contain,
            ),
          ),
          buttonTextStyle: CustomTextStyles.titleSmallDMSansWhiteA700,
          buttonStyle: CustomButtonStyles.fillPrimary,
          onPressed: () => onTap?.call(),
        ),
      ),
    );
  }
}
