import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/contract_controller.dart';
import 'package:xm_frontend/features/shop/controllers/tenant/tenant_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/create_tenant.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/edit_tenant.dart';
import 'package:xm_frontend/features/shop/screens/tenant/dialogs/view_tenant.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class TenantTab extends StatelessWidget {
  const TenantTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerTenant = Get.find<TenantController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for the search, button, and filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align to the right
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: TColors.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const EditTenantDialog();
                    },
                  );

                  if (result == true) {}
                },
                icon: const Icon(
                  Iconsax.edit,
                  size: 20,
                  color: TColors.primary,
                ),
                label: Text(
                  AppLocalization.of(
                    context,
                  ).translate('general_msgs.msg_edit'),
                  style: TextStyle(color: TColors.primary),
                ),
              ),

              const SizedBox(width: TSizes.spaceBtwInputFields),

              // TextButton.icon(
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.red.withOpacity(0.1),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   onPressed: () {
              //     // Open filter options dialog
              //   },
              //   icon: const Icon(
              //     Iconsax.profile_delete,
              //     size: 20,
              //     color: Colors.red,
              //   ),
              //   label: Text(
              //     AppLocalization.of(
              //       context,
              //     ).translate('general_msgs.msg_delete'),
              //     style: TextStyle(color: Colors.red),
              //   ),
              // ),
            ],
          ),

          Obx(() {
            // display just one tenant
            final tenant = controllerTenant.tenantModel.value;

            return Expanded(child: _buildTenantPage(tenant, context));
          }),
        ],
      ),
    );
  }

  Widget _buildTenantPage(UserModel tenant, BuildContext context) {
    return SizedBox(
      width: 450,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('tenants_screen.lbl_first_name'),
            tenant.firstName.toString(),
          ),
          const Divider(),
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('tenants_screen.lbl_last_name'),
            tenant.lastName.toString(),
          ),
          const Divider(),
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('tenants_screen.lbl_phone_no'),
            tenant.fullPhoneNumber.toString(),
          ),
          const Divider(),
          _buildInfoRow(
            AppLocalization.of(context).translate('tenants_screen.lbl_email'),
            tenant.email.toString(),
          ),
          const Divider(),
          if (tenant.lang.isNotEmpty) ...[
            _buildInfoRow(
              AppLocalization.of(
                context,
              ).translate('tenants_screen.lbl_preferred_language'),
              tenant.lang.toString(),
              isLang: true,
            ),
            const Divider(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLang = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child:
                isLang
                    ? Row(
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Icon(
                            Iconsax.language_circle5,
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
