import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/features/shop/controllers/request/request_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';

class ViewRequestTimelineDialog extends StatelessWidget {
  const ViewRequestTimelineDialog({
    super.key,
    this.requestId,
    required this.tag,
  });

  final int? requestId;
  final String tag;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<RequestController>();

    final controller = Get.find<RequestController>(tag: tag);

    controller.loadRequestLogs(requestId!);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TRoundedContainer(
        width: 400,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalization.of(
                    context,
                  ).translate('view_request_screen.lbl_timeline'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Fixed scrollable content
            SizedBox(
              height: 300,
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.requestLogs.length,
                  itemBuilder: (context, index) {
                    final log = controller.requestLogs[index];
                    final currentStatus = controller.requestModel.value.status;
                    final currentIndex = controller.requestLogs.indexWhere(
                      (log) => log.status == currentStatus,
                    );
                    final isComplete =
                        index <=
                        (currentIndex == -1
                            ? controller.requestLogs.length - 1
                            : currentIndex);
                    final isFirst = index == 0;
                    final isLast = index == controller.requestLogs.length - 1;

                    return TimelineTile(
                      isFirst: isFirst,
                      isLast: isLast,
                      beforeLineStyle: LineStyle(
                        color: isComplete ? Colors.green : Colors.grey,
                        thickness: 4,
                      ),
                      indicatorStyle: IndicatorStyle(
                        width: 25,
                        color: isComplete ? Colors.green : Colors.grey,
                        iconStyle: IconStyle(
                          iconData: isComplete ? Icons.check : Icons.circle,
                          color: Colors.white,
                        ),
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: FutureBuilder<String>(
                            future: TranslationApi.smartTranslate(
                              log.statusText,
                            ),
                            builder: (context, snapshot) {
                              final translated =
                                  snapshot.data ?? log.statusText;
                              return Text(
                                translated,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_formatDateTime(log.createdAt)),
                              if (log.description.isNotEmpty)
                                FutureBuilder<String>(
                                  future: TranslationApi.smartTranslate(
                                    log.description,
                                  ),
                                  builder: (context, snapshot) {
                                    final translated =
                                        snapshot.data ?? log.description;
                                    return Text(
                                      translated,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              if (log.adminViewProcessedBy != null)
                                Text(log.adminViewProcessedBy),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
