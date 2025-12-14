import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/models/docs_model.dart';
import 'package:cartakers/utils/popups/loaders.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';

class PDFViewerPage extends StatefulWidget {
  final DocsModel doc;

  const PDFViewerPage({super.key, required this.doc});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PdfControllerPinch? _pdfControllerPinch;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _loadPdf(widget.doc.fileUrl);
  }

  // Function to download and load the PDF from URL
  Future<void> _loadPdf(String pdfUrl) async {
    try {
      final response = await Dio().get(
        pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data as Uint8List;

      // Only load the PDF for viewing, no download here
      _pdfControllerPinch = PdfControllerPinch(
        document: PdfDocument.openData(bytes),
      );

      setState(() {});
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  // Zoom In function
  void _zoomIn() {
    setState(() {
      _zoomLevel += 0.1;
      _pdfControllerPinch?.goTo(
        destination: Matrix4.identity()..scale(_zoomLevel),
        duration: Duration(milliseconds: 200),
      );
    });
  }

  // Zoom Out function
  void _zoomOut() {
    setState(() {
      _zoomLevel -= 0.1;
      _pdfControllerPinch?.goTo(
        destination: Matrix4.identity()..scale(_zoomLevel),
        duration: Duration(milliseconds: 200),
      );
    });
  }

  // Function to download the PDF
  Future<void> _downloadPdf(BuildContext context, String url) async {
    try {
      // For Web: Trigger the download using Blob (browser download)
      if (kIsWeb) {
        final response = await Dio().get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = response.data as Uint8List;

        final blob = html.Blob([bytes]);
        final urlBlob = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement(href: urlBlob)
              ..target = 'blank'
              ..download = 'downloaded_pdf.pdf'
              ..click();
        html.Url.revokeObjectUrl(urlBlob);

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_download_completed'),
        );
      } else {
        // For non-web (iOS & Android): Request permission for storage (Android)
        if (Platform.isAndroid) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            TLoaders.errorSnackBar(
              title: AppLocalization.of(
                Get.context!,
              ).translate('general_msgs.msg_error'),
              message: AppLocalization.of(
                Get.context!,
              ).translate('general_msgs.msg_storage_permission_denied'),
            );
            return;
          }
        }

        // Open file picker for directory selection (Android & iOS)
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory == null) {
          // User canceled directory selection
          TLoaders.warningSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_warning'),
            message: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_download_cancelled'),
          );
          return;
        }

        // Generate file path
        final fileName = url.split('/').last;
        final filePath = '$selectedDirectory/$fileName';

        // Download the PDF file
        final dio = Dio();
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_downloading'),
        );

        await dio.download(url, filePath);

        // Show success message

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message:
              '${AppLocalization.of(Get.context!).translate('general_msgs.msg_file_saved_to')} $filePath',
        );
      }
    } catch (e) {
      // Handle download errors
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_download_failed'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc.fileName.value),

        actions: [
          TextButton.icon(
            onPressed: () {
              // Open the PDF in a new tab
              if (kIsWeb) {
                html.window.open(widget.doc.fileUrl, '_blank');
              } else {
                // For mobile, use the download function
                _downloadPdf(context, widget.doc.fileUrl);
              }
            },

            icon: const Icon(Icons.download),
            label: Text(
              AppLocalization.of(
                context,
              ).translate('general_msgs.msg_download'),
            ),
          ),
        ],
      ),
      body:
          _pdfControllerPinch == null
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loading spinner until controller is ready
              : Column(
                children: [
                  // Zoom controls row
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.zoom_in),
                          onPressed: _zoomIn,
                        ),
                        IconButton(
                          icon: Icon(Icons.zoom_out),
                          onPressed: _zoomOut,
                        ),
                      ],
                    ),
                  ),
                  // PDF View with centered content
                  Expanded(
                    child: Center(
                      // Ensures the PDF is always centered
                      child: PdfViewPinch(
                        controller:
                            _pdfControllerPinch!, // The controller to manage zooming and page movement
                      ),
                    ),
                  ),
                  // Download button
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _downloadPdf(context, widget.doc.fileUrl);
                  //     },
                  //     child: Text('Download PDF'),
                  //   ),
                  // ),
                ],
              ),
    );
  }
}
