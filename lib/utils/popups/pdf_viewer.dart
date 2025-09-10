import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class PDFViewerScreen extends StatefulWidget {
  final String assetPath;
  const PDFViewerScreen({super.key, required this.assetPath});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    preparePdf();
  }

  Future<void> preparePdf() async {
    final bytes = await rootBundle.load(widget.assetPath);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/nda.pdf');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (localPath == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('NDA')),
      body: PDFView(
        filePath: localPath!,
      ),
    );
  }
}