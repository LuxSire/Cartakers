import 'package:xm_frontend/utils/constants/enums.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/media/models/image_model.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  // Firebase Storage instance

  /// Upload any Image using File
  Future<void> uploadImageFileInStorage({
    required html.File file,
    required String path,
    required String imageName,
  }) async {
    //  return ImageModel.fromFirebaseMetadata('metadata', path, imageName, 'downloadURL');
  }

  /// Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    return 'imageId';
  }

  // Fetch images from Firestore based on media category and load count
  Future<List<ImageModel>> fetchImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
  ) async {
    return [];
  }

  // Load more images from Firestore based on media category, load count, and last fetched date
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedDate,
  ) async {
    return [];
  }

  // Fetch all images from Firebase Storage
  Future<List<ImageModel>> fetchAllImages() async {
    return [];
  }

  // Delete file from Firebase Storage and corresponding document from Firestore
  Future<void> deleteFileFromStorage(ImageModel image) async {
    return;
  }
}
