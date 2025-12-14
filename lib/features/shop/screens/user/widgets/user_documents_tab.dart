import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/common/widgets/loaders/animation_loader.dart';
//import 'package:cartakers/data/models/contract_model.dart';
import 'package:cartakers/data/models/docs_model.dart';
import 'package:cartakers/features/shop/controllers/contract/permission_controller.dart';
import 'package:cartakers/features/shop/controllers/document/document_controller.dart';
import 'package:cartakers/features/personalization/controllers/user_controller.dart';
//import 'package:cartakers/features/shop/screens/contract/dialogs/edit_contract.dart';
import 'package:cartakers/features/shop/screens/document/file_detail_dialog.dart';
import 'package:cartakers/features/shop/screens/document/file_rename_dialog.dart';
import 'package:cartakers/features/shop/screens/document/img_viewer_page.dart';
import 'package:cartakers/features/shop/screens/document/pdf_viewer_page.dart';
import 'package:cartakers/features/shop/screens/document/web_view_page.dart';
import 'package:cartakers/utils/constants/colors.dart';
import 'package:cartakers/utils/constants/image_strings.dart';
import 'package:cartakers/utils/constants/sizes.dart';
import 'package:cartakers/utils/device/device_utility.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';

class UserDocumentsTab extends StatelessWidget {
  const UserDocumentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the DocumentController is created only once
    final controllerUser = Get.find<UserController>();
    String userID=controllerUser.userModel.value.id.toString();
    final controllerDocument = Get.put(
      DocumentController(
        userId: int.parse(userID,
        ),
      ),
    );

    // Load the data once during initialization
    controllerDocument.loadData();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for the search, button, and filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align to the right
            children: [
              // TextField
              Expanded(
                flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
                child: TextFormField(
                  onChanged: (query) => controllerDocument.filterDocs(query),
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(
                      context,
                    ).translate('contract_screen.lbl_search_documents'),
                    prefixIcon: Icon(Iconsax.search_normal),
                  ),
                ),
              ),

              const SizedBox(width: TSizes.spaceBtwItems),
              // Button
              TextButton.icon(
                onPressed: () async {
                  // Pick a file
                  final pickedFile = await controllerDocument.pickFile();
                  if (pickedFile != null) {
                    // Upload the file to Azure
                    final uploadResponse = await controllerDocument
                        .uploadUserDocumentToAzure(
                          pickedFile,
                          int.parse( controllerUser.userModel.value.id.toString()),
                        );

                    if (uploadResponse) {
                      // If upload was successful, reload the documents
                      controllerDocument.loadData();
                      //  Get.snackbar("Success", "Document uploaded successfully.");
                    }
                  }
                },

                icon: const Icon(Icons.upload, color: TColors.alterColor),
                label: Text(
                  style: TextStyle(color: TColors.alterColor),
                  AppLocalization.of(
                    context,
                  ).translate('contract_screen.lbl_upload_new_document'),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwItems),
          // Grid of documents
          Expanded(
            child: Obx(() {
              if (controllerDocument.filteredDocs.isEmpty) {
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
              return GridView.builder(
                itemCount: controllerDocument.filteredDocs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      TDeviceUtils.isDesktopScreen(context)
                          ? 3
                          : TDeviceUtils.isTabletScreen(context)
                          ? 2
                          : 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  mainAxisExtent: 100,
                ),
                itemBuilder: (context, index) {
                  return _buildDocumentCard(
                    controllerDocument.filteredDocs[index].fileName.value,
                    controllerDocument.filteredDocs[index].updatedAt,
                    controllerDocument.filteredDocs[index].fileUrl,
                    controllerDocument.filteredDocs[index],
                    controllerDocument
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    String documentName,
    DateTime date,
    String url,
    DocsModel doc,
    DocumentController controller
  ) {
    final fileType = url.split('.').last.toLowerCase();

    // get file name from url
    final fileName = THelperFunctions.extractFileName(url, 'docs');

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // File type icon box
          Container(
            height: double.infinity,
            width: 70,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Icon(
              fileType == 'pdf'
                  ? Icons.picture_as_pdf
                  : ['jpg', 'jpeg', 'png', 'gif'].contains(fileType)
                  ? Icons.image
                  : [
                    'doc',
                    'docx',
                    'xls',
                    'xlsx',
                    'ppt',
                    'pptx',
                    'txt',
                  ].contains(fileType)
                  ? Icons.description
                  : Iconsax.global,
              color: TColors.primary,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          // File info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(
                    doc.fileName.value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                const SizedBox(height: 4),
                Text(
                  THelperFunctions.getDateTimeAbreviated(date),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  doc.creatorName ??
                      AppLocalization.of(
                        Get.context!,
                      ).translate('general_msgs.msg_unknown'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Options menu
          Align(
            alignment: Alignment.center,
            child: PopupMenuButton<String>(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              offset: const Offset(0, 40),
              color: Colors.white,
              onSelected: (value) async {
                // Handle options (open, view, delete, etc.)
                if (value == 'open') {
                  // Open the document

                  if (fileType == 'pdf') {
                    _openPdf(doc);
                  } else if (['jpg', 'jpeg', 'png', 'gif'].contains(fileType)) {
                    showDialog(
                      context: Get.context!,
                      builder: (BuildContext context) {
                        return ImageDialogViewer(
                          imageUrl: doc.fileUrl,
                          imageName: doc.fileName.value,
                        );
                      },
                    );
                  } else {
                    if ([
                      'doc',
                      'docx',
                      'xls',
                      'xlsx',
                      'ppt',
                      'pptx',
                      'txt',
                    ].contains(fileType)) {
                      controller.openDocument(
                        doc.fileUrl,
                      ); // Open in external app
                    } else {
                      // Open in WebView
                      Get.to(() => WebViewScreen(url: doc.fileUrl));
                    }
                  }
                } else if (value == 'view') {
                  // View details
                  int fileSize = await THelperFunctions.getFileSizeFromUrl(
                    doc.fileUrl,
                  );

                  showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return FileDetailsDialog(
                        fileName: doc.fileName.value,
                        fileType: fileType,
                        creationDate:
                            doc.updatedAt, // Example date, replace with actual
                        fileSize:
                            fileSize, // Example file size in bytes, replace with actual size
                        createdBy:
                            doc.creatorName ??
                            AppLocalization.of(
                              Get.context!,
                            ).translate('general_msgs.msg_unknown'),
                      );
                    },
                  );
                } else if (value == 'delete') {
                  // Handle delete

                  final deleteResponse = await controller
                      .deleteDocumentFromAzure(
                        doc.fileName.value.toString(),
                        'docs',
                         doc.fileUrl,
                      );

                  if (deleteResponse) {
                    controller.loadData();
                  }
                } else if (value == 'rename') {
                  final updatedFileName = await showDialog<String>(
                    context: Get.context!,
                    //     barrierDismissible: false,
                    builder: (BuildContext context) {
                      return RenameFileDialog(
                        currentFileName: doc.fileName.value,
                        documentId: doc.id,
                      );
                    },
                  );

                  if (updatedFileName != null) {
                    doc.fileName.value = updatedFileName;
                  }
                }
              },

              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'open',
                    child: Row(
                      children: [
                        const Icon(Icons.file_open, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_open'),
                        ),
                      ],
                    ),
                  ),
                  
                  PopupMenuItem<String>(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(Icons.visibility, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_view_details'),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_delete'),
                        ),
                      ],
                    ),
                  ),
                    PopupMenuItem<String>(
                    value: 'rename',
                    child: Row(
                      children: [
                        const Icon(Icons.read_more, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalization.of(
                            Get.context!,
                          ).translate('general_msgs.msg_rename'),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the filter dialog
  void _showFilterDialog(BuildContext context, DocumentController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                onTap: () {
                  controller.filterDocs(''); // No filter, show all documents
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Contract'),
                onTap: () {
                  controller.filterDocs('Contract'); // Filter by 'Contract'
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Certificate'),
                onTap: () {
                  controller.filterDocs(
                    'Certificate',
                  ); // Filter by 'Certificate'
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to open the PDF document
  void _openPdf(DocsModel doc) {
    // Navigate to the PDF viewer screen
    Get.to(() => PDFViewerPage(doc: doc));
  }
}
