import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:iconsax/iconsax.dart';
import 'package:xm_frontend/data/models/docs_model.dart';
import 'package:xm_frontend/features/shop/controllers/object/edit_object_controller.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import 'package:xm_frontend/features/shop/controllers/document/document_controller.dart';


class ObjectPicsWidget extends StatelessWidget {
  final int objectId;
  const ObjectPicsWidget({super.key, required this.objectId});


  @override
  Widget build(BuildContext context) {
    DocumentController controller = Get.put(DocumentController());
    final RxInt reloadKey = 0.obs;

    return TRoundedContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Document List',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onChanged: (query) {
                      // You may want to connect this to a controller if you have one for objects
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalization.of(context).translate('contract_screen.lbl_search_documents'),
                      prefixIcon: Icon(Iconsax.search_normal),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () async {
                    final controller = Get.find<EditObjectController>();
                    final pickedFile = await controller.pickFile();
                    if (pickedFile != null) {
                      await controller.uploadDocumentToAzure(pickedFile, objectId);
                    }
                  },
                  icon: const Icon(Icons.upload, color: Colors.blue),
                  label: Text(
                    AppLocalization.of(context).translate('contract_screen.lbl_upload_new_document'),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => FutureBuilder<List<DocsModel>>(
              key: ValueKey(reloadKey.value),
              future: ObjectRepository.instance.fetchObjectImages(objectId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final docs = snapshot.data ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalization.of(context).translate('contract_screen.lbl_no_documents_found'),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return SizedBox(
                  height: 300, // Adjust height as needed
                  child: ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return ListTile(
                        leading: Icon(Iconsax.document),
                        title: Text(doc.fileName.value),
                        subtitle: Text(doc.createdAt.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              tooltip: AppLocalization.of(context).translate('general_msgs.msg_view_details'),
                              onPressed: () {
                                doc.view(context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: AppLocalization.of(context).translate('general_msgs.msg_rename'),
                              onPressed: () async {
                                //doc.rename(context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: AppLocalization.of(context).translate('general_msgs.msg_delete'),
                              onPressed: () async {
                                final deleteResponse = await controller
                                    .deleteDocumentFromAzure(
                                  doc.fileName.value.toString(),
                                  'docs',
                                  doc.fileUrl,
                                );
                                if (deleteResponse) {
                                  controller.loadData();
                                  reloadKey.value++; // This will trigger a rebuild
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
                            //
