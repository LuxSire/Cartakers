import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/common/widgets/images/t_rounded_image.dart';
import 'package:xm_frontend/common/widgets/loaders/animation_loader.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:xm_frontend/features/shop/screens/contract/dialogs/update_request.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:xm_frontend/utils/constants/image_strings.dart';
import 'package:xm_frontend/utils/constants/sizes.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';

class RequestsCard extends StatelessWidget {
  const RequestsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final companyId = AuthenticationRepository.instance.currentUser?.companyId;

    final controllerRequest = Get.put(
      RequestController(
        sourceType: RequestSourceType.company,
        id: int.parse(companyId!),
      ),
      tag: 'company_requests',
    );
    controllerRequest.loadData();

    final requestList = controllerRequest.allPendingRequests;

    // order by date

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final requests = requestList;

          if (requests.isEmpty) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: TAnimationLoaderWidget(
                    height: 250,
                    text: AppLocalization.of(
                      context,
                    ).translate('general_msgs.msg_no_data_found'),
                    animation: TImages.noDataIllustration,
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 455,
            child: ListView.separated(
              itemCount: requests.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final request = requests[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: TRoundedImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    padding: 2,
                    imageType:
                        request.createdByUserProfileImageUrl!.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                    image:
                        request.createdByUserProfileImageUrl!.isNotEmpty
                            ? request.createdByUserProfileImageUrl!
                            : TImages.user,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.createdByName!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TColors.txt333333,
                        ),
                      ),
                      const SizedBox(height: TSizes.xs),
                      Text(
                        request.objectName!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: TColors.txt666666,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TSizes.xs),
                      Text(
                        '${request.formattedDateWithText} • ${request.ticketNumber}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 4),
                      Text(
                        request.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: TColors.txt666666,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        request.requestType ?? '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TColors.txt333333,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final updatedRequest = await showDialog<RequestModel>(
                            context: Get.context!,
                            barrierDismissible: false,
                            builder:
                                (_) => UpdateRequestDialog(
                                  request: request,
                                  tag: 'agency_requests',
                                ),
                          );

                          if (updatedRequest != null) {
                            controllerRequest.loadData();

                            final controllerDashboard =
                                Get.find<DashboardController>();

                            controllerDashboard.fetchTotalPendingRequests();
                          }
                        },
                        child: const Icon(Iconsax.edit, color: TColors.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
