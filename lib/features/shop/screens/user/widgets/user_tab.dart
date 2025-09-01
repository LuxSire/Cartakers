import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/common/widgets/images/t_circular_image.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/contract/permission_controller.dart';
//import 'package:xm_frontend/features/shop/controllers/user/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/company_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/create_contract.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/create_user.dart';
import 'package:xm_frontend/features/shop/screens/settings_managements/dialogs/edit_user.dart';
import 'package:xm_frontend/features/shop/screens/user/dialogs/view_user.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/device/device_utility.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class UserTab extends StatelessWidget {
  const UserTab({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controllerUser = Get.find<UserController>();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Obx(() {
      final user = controllerUser.userModel.value;
      // You may want to check if user is not empty/null here
      return _buildUserPage(user, context);
    }),
  );
}

  Widget _buildUserPage(UserModel user, BuildContext context) {
    return SizedBox(
      width: 450,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('users_screen.lbl_first_name'),
            user.firstName.toString(),
          ),
          const Divider(),
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('users_screen.lbl_last_name'),
            user.lastName.toString(),
          ),
          const Divider(),
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('users_screen.lbl_phone_no'),
            user.phoneNumber.toString(),
          ),
          const Divider(),
                        // Company Dropdown
          _buildInfoRow(
            AppLocalization.of(
              context,
            ).translate('tab_users_screen.lbl_company'),
            user.companyName.toString(),
          ),
           const Divider(),
          Row(
           
  children: [
    Text(
      'Refresh Token',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.refresh, color: TColors.primary, size: 20),
      tooltip: 'Update Token',
      onPressed: () {
        final controllerUser = Get.find<UserController>();
        controllerUser.updateTokenByUser(user);
      },
    ),
  ],
          ),
          const Divider(),
          _buildInfoRow(
            AppLocalization.of(context).translate('users_screen.lbl_email'),
            user.email.toString(),
          ),
          const Divider(),
          if (user.lang.isNotEmpty) ...[
            _buildInfoRow(
              AppLocalization.of(
                context,
              ).translate('users_screen.lbl_preferred_language'),
              user.lang.toString(),
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
                //color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                         //   color: TColors.primary,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                       // color: Colors.black87,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
