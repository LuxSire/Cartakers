import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';

/// A collection of pre-defined text styles for customizing text appearance.
/// Includes static (context-independent) and dynamic (theme-dependent) styles.
class CustomTextStyles {
  // Static Styles (Predefined, No Context)
  static const TextStyle bodyMediumStatic = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lato',
    color: AppColors.gray700,
  );

  static const TextStyle headlineSmallStatic = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: AppColors.whiteA700,
  );

  static const TextStyle labelLargeRedA70002 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'DM Sans',
    color: AppColors.redA70002,
  );

  static const TextStyle titleSmallGray700Static = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
    color: AppColors.gray700,
  );

  static const TextStyle titleSmallGray700Medium = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Lato',
    color: AppColors.gray700,
  );

  static const TextStyle titleSmallDMSansWhiteA700 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'DM Sans',
    color: AppColors.whiteA700,
  );

  static const TextStyle titleSmallDMSansSemiBold = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'DM Sans',
    color: AppColors.blueGray90001,
  );

  static const TextStyle titleSmallDMSansGray700 = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'DM Sans',
    color: AppColors.gray700,
  );

  static const TextStyle bodyMediumDMSansRedA700 = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'DM Sans',
    color: AppColors.redA700,
  );

  static const TextStyle titleMediumDMSans = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'DM Sans',
    color: AppColors.whiteA700,
  );

  static const TextStyle titleMediumDMSansPrimary = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'DM Sans',
    color: AppColors.primaryColor,
  );

  static const TextStyle btnHighlight = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'Lato',
    color: AppColors.whiteA700,
  );

  static const TextStyle labelLargeDMSansGray700SemiBold = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'DM Sans',
    color: AppColors.gray700,
  );

  static const TextStyle titleLargeDMSans = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'DM Sans',
    color: AppColors.blueGray90001,
  );
  // Dynamic Styles (Theme-dependent)
  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.gray700,
      );

  static TextStyle headlineSmall(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  static TextStyle titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.redA700,
      );

  static TextStyle labelLargeRed(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: AppColors.redA70002,
      );

  static TextStyle labelLargeOnPrimaryContainer(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(1),
      );

  static TextStyle titleSmallGray700(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: AppColors.gray700,
      );

  static const TextStyle labelLargeBlack900 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Lato',
    color: AppColors.black900,
  );

  // Extended Font Family Styles
  static TextStyle bodyMediumDMSans(BuildContext context) =>
      bodyMedium(context).copyWith(fontFamily: 'DM Sans');

  static TextStyle labelLargeDMSans(BuildContext context) =>
      labelLarge(context).copyWith(fontFamily: 'DM Sans');

  static TextStyle titleSmallPoppins(BuildContext context) =>
      titleSmall(context).copyWith(fontFamily: 'Poppins');

  static TextStyle headlineSmallLato(BuildContext context) =>
      headlineSmall(context).copyWith(fontFamily: 'Lato');

  static TextStyle titleSmallInter(BuildContext context) =>
      titleSmall(context).copyWith(fontFamily: 'Inter');

  static TextStyle labelLargeRedA70002Dynamic(BuildContext context) =>
      labelLarge(context).copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: AppColors.redA70002,
        fontFamily: 'DM Sans',
      );
}
