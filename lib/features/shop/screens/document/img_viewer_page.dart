import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:xm_frontend/app/utils/size_utils.dart';

class ImageDialogViewer extends StatelessWidget {
  final String imageUrl;
  final String imageName;

  const ImageDialogViewer({
    super.key,
    required this.imageUrl,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    // Safely get the device's screen width
    double width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: 1, // Since we're only showing one image
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder:
                (context, event) =>
                    const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 16.0, // Adjust the top positioning as needed
            right: 16.0, // Adjust the right positioning as needed
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 30, // Adjust the size of the close icon
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog when clicked
              },
            ),
          ),
        ],
      ),
    );
  }
}
