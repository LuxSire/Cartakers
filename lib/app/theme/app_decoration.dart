import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlack =>
      const BoxDecoration(color: AppColors.black900);
  static BoxDecoration get fillBlue =>
      const BoxDecoration(color: AppColors.blue5001);
  static BoxDecoration get fillBlueGray =>
      const BoxDecoration(color: AppColors.blueGray90001);
  static BoxDecoration get fillBluegray90001 =>
      BoxDecoration(color: AppColors.blueGray90001.withOpacity(0.05));
  static BoxDecoration get fillDeepOrange =>
      const BoxDecoration(color: AppColors.deepOrange50);
  static BoxDecoration get fillDeeporange5001 =>
      const BoxDecoration(color: AppColors.deepOrange5001);
  static BoxDecoration get fillGray =>
      const BoxDecoration(color: AppColors.gray50);
  static BoxDecoration get fillGray200 =>
      const BoxDecoration(color: AppColors.gray200);
  static BoxDecoration get fillGreenA =>
      BoxDecoration(color: AppColors.greenA700.withOpacity(0.1));
  static BoxDecoration fillPrimary(BuildContext context) =>
      BoxDecoration(color: Theme.of(context).colorScheme.primary);
  static BoxDecoration fillPrimary1(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
  );
  static BoxDecoration get fillRedA =>
      const BoxDecoration(color: AppColors.redA700);
  static BoxDecoration fillSecondaryContainer(BuildContext context) =>
      BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer);
  static BoxDecoration get fillWhiteA =>
      const BoxDecoration(color: AppColors.whiteA700);

  // Gradient decorations
  static BoxDecoration gradientBlueToIndigo = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0, 0.03),
      end: Alignment(0.93, 0.41),
      colors: [AppColors.blue600, AppColors.indigo900],
    ),
  );

  static BoxDecoration gradientPrimaryToWhiteA(BuildContext context) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            AppColors.whiteA700.withOpacity(0.14),
            AppColors.whiteA700,
          ],
        ),
      );

  // Grey decorations
  static BoxDecoration grey4 = BoxDecoration(
    color: AppColors.whiteA700,
    border: Border.all(color: AppColors.blueGray100, width: 1),
  );

  // Outline decorations
  static BoxDecoration get outline =>
      BoxDecoration(color: AppColors.blueGray90001.withOpacity(0.2));
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: AppColors.whiteA700,
    boxShadow: [
      BoxShadow(
        color: AppColors.black900.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 0),
      ),
    ],
  );
  static BoxDecoration get outlineBlueGray =>
      BoxDecoration(border: Border.all(color: AppColors.blueGray100, width: 1));
  static BoxDecoration get outlinePrimary =>
      const BoxDecoration(color: AppColors.blue50);
  static BoxDecoration get outlineTeal => BoxDecoration(
    color: AppColors.greenA700,
    border: Border.all(
      color: AppColors.teal400,
      width: 2,
      strokeAlign: BorderSide.strokeAlignOutside,
    ),
  );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder12 => BorderRadius.circular(12);
  static BorderRadius get circleBorder22 => BorderRadius.circular(22);
  static BorderRadius get circleBorder32 => BorderRadius.circular(32);
  static BorderRadius get circleBorder40 => BorderRadius.circular(40);

  // Custom borders
  static BorderRadius get customBorderTL20 => const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );
  static BorderRadius get customBorderTL201 => const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );
  static BorderRadius get customBorderTL8 =>
      const BorderRadius.horizontal(left: Radius.circular(8));

  // Rounded borders
  static BorderRadius get roundedBorder18 => BorderRadius.circular(18);
  static BorderRadius get roundedBorder48 => BorderRadius.circular(48);
  static BorderRadius get roundedBorder8 => BorderRadius.circular(8);
}
