import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomMediaPicker extends StatefulWidget {
  final void Function(List<PlatformFile> files) onFilesSelected;
  final bool allowMultiple;

  const CustomMediaPicker({
    super.key,
    required this.onFilesSelected,
    this.allowMultiple = true,
  });

  @override
  State<CustomMediaPicker> createState() => _CustomMediaPickerState();
}

class _CustomMediaPickerState extends State<CustomMediaPicker> {
  List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.allowMultiple,
      type: FileType.image,
      withData: true, // Important for displaying image previews
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles = result.files;
      });
      widget.onFilesSelected(_selectedFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Select Button
        ElevatedButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text("Select Images"),
        ),

        const SizedBox(height: 16),

        /// Grid preview
        _selectedFiles.isEmpty
            ? const Text("No images selected.")
            : Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  _selectedFiles.map((file) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        image:
                            file.bytes != null
                                ? DecorationImage(
                                  image: MemoryImage(file.bytes!),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          file.bytes == null
                              ? const Center(child: Icon(Icons.broken_image))
                              : null,
                    );
                  }).toList(),
            ),
      ],
    );
  }
}
