import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/routes/routes.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class ViewTenantDialog extends StatelessWidget {
  const ViewTenantDialog({super.key, this.tenant, this.contractCode});

  final UserModel? tenant;
  final String? contractCode;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TenantController());

    //  debugPrint('Tenant: ${tenant!.toJson().toString()}');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 500,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with close icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.of(
                      context,
                    ).translate('tenants_screen.lbl_tenant'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TCircularImage(
                      width: 120,
                      height: 120,
                      padding: 2,
                      fit: BoxFit.cover,
                      backgroundColor: TColors.alterColor,
                      image:
                          tenant!.profilePicture.isNotEmpty
                              ? tenant!.profilePicture
                              : TImages.user,
                      imageType:
                          tenant!.profilePicture.isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          tenant!.fullName,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        Text(
                          tenant!.email,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: TColors.black.withOpacity(0.5)),
                        ),

                        Text(
                          tenant!.fullPhoneNumber!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: TColors.black.withOpacity(0.5)),
                        ),
                        Text(
                          contractCode!,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        if (tenant!.isPrimaryTenant == 1)
                          Column(
                            children: [
                              const SizedBox(
                                height: TSizes.spaceBtwInputFields,
                              ),
                              TRoundedContainer(
                                radius: TSizes.cardRadiusSm,
                                padding: const EdgeInsets.symmetric(
                                  vertical: TSizes.sm,
                                  horizontal: TSizes.md,
                                ),
                                backgroundColor: TColors.alterColor.withOpacity(
                                  0.1,
                                ),
                                child: Text(
                                  AppLocalization.of(context).translate(
                                    'tenants_screen.lbl_primary_tenant',
                                  ),
                                  style: TextStyle(color: TColors.alterColor),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwInputFields),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.tenantDetails, arguments: tenant)?.then((
                      result,
                    ) {
                      if (result == true) {}
                    });
                  },
                  child: Text(
                    AppLocalization.of(
                      context,
                    ).translate('general_msgs.msg_view_full_details'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
