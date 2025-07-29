import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // **Filled Button Styles**
  static ButtonStyle get fillBlueGray => ElevatedButton.styleFrom(
    backgroundColor: AppColors.blueGray100,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillRedA => ElevatedButton.styleFrom(
    backgroundColor: AppColors.redA700,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  // **Outlined Button Styles (Light Theme)**
  static ButtonStyle get outlineBlueGray => OutlinedButton.styleFrom(
    backgroundColor: AppColors.gray20001,
    side: const BorderSide(color: AppColors.blueGray100, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineGreen => OutlinedButton.styleFrom(
    backgroundColor: AppColors.greenA700.withOpacity(0.1),
    side: const BorderSide(color: AppColors.greenA700, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineOrange => OutlinedButton.styleFrom(
    backgroundColor: AppColors.orange925.withOpacity(0.1),
    side: const BorderSide(color: AppColors.orange925, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineYellow => OutlinedButton.styleFrom(
    backgroundColor: AppColors.orange50,
    side: const BorderSide(color: AppColors.yellow700, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  // **Outlined Button Styles (Dark Theme)**
  static ButtonStyle get outlineBlueGrayDark => OutlinedButton.styleFrom(
    backgroundColor: AppColors.blueGray900.withOpacity(0.1),
    side: const BorderSide(color: AppColors.blueGray900, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineGreenDark => OutlinedButton.styleFrom(
    backgroundColor: AppColors.greenA700.withOpacity(0.2),
    side: const BorderSide(color: AppColors.greenA700, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get outlineOrangeDark => OutlinedButton.styleFrom(
    backgroundColor: AppColors.orange925.withOpacity(0.2),
    side: const BorderSide(color: AppColors.orange925, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle get fillWhiteATL8 => ElevatedButton.styleFrom(
    backgroundColor: AppColors.whiteA700.withOpacity(1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );

  // **Dynamic Theme-Based Styles**
  static ButtonStyle outlinePrimary(BuildContext context) =>
      OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: EdgeInsets.zero,
      );

  static ButtonStyle outlineOnPrimaryContainer(BuildContext context) {
    return OutlinedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      side: BorderSide(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(1),
        width: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.zero,
    );
  }

  // **Text Button Styles**
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    elevation: MaterialStateProperty.all<double>(0),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
    side: MaterialStateProperty.all<BorderSide>(
      const BorderSide(color: Colors.transparent),
    ),
  );
}
