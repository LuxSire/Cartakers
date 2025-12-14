import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/data/models/docs_model.dart';
import 'package:cartakers/features/shop/controllers/object/object_controller.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/app/localization/app_localization.dart';

class ObjectDocsWidget extends StatelessWidget {
  final int objectId;
  const ObjectDocsWidget({super.key, required this.objectId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocsModel>>(
      future: ObjectRepository.instance.fetchObjectDocs(objectId),
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
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final doc = docs[index];
            return ListTile(
              leading: Icon(Iconsax.document),
              title: Text(doc.fileName.value),
              subtitle: Text(doc.updatedAt.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    tooltip: AppLocalization.of(context).translate('general_msgs.msg_view_details'),
                    onPressed: () {
                      // Implement view logic (e.g., open PDF/image/webview)
                      //ObjectController.instance.viewDoc(doc);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: AppLocalization.of(context).translate('general_msgs.msg_rename'),
                    onPressed: () async {
                      // Implement rename logic (e.g., show dialog)
                      //await ObjectController.instance.renameDoc(doc);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: AppLocalization.of(context).translate('general_msgs.msg_delete'),
                    onPressed: () async {
                      final deleted = false; //= await ObjectController.instance.deleteDoc(doc);
                    },  
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
