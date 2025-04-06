import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

import '../apis/apis.dart';
import '../helper/global.dart';
import '../helper/my_dialog.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();

  final status = Status.none.obs;

  final url = ''.obs;

  final imageList = <String>[].obs;
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting; // e.g., 'enhance', 'anime', etc.

  // Generate image using Stability AI
  Future<void> createAIImage() async {
    if (textC.text.trim().isNotEmpty) {
      try {
        status.value = Status.loading;

        // Get image data from Stability AI
        final imageData = await APIs.generateImage(
          prompt: textC.text.trim(),
          stabilityApiKey: stabilityApiKey,
          imageAIStyle: imageAIStyle,
        );

        // Save image to temporary file
        // Save image to temporary file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/stability_image_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(imageData as List<int>);
        url.value = file.path;
        if (!imageList.contains(file.path)) {
          imageList.add(file.path);
        }

        status.value = Status.complete;
      } catch (e) {
        status.value = Status.none;
        Get.snackbar('Error', 'Failed to generate image: $e');
      }
    } else {
      Get.snackbar('Empty Field', 'Please type something to create an image');
    }
  }






  void downloadImage() async {
    try {
      MyDialog.showLoadingDialog();

      log('url: $url');

      final file = File(url.value); // Assume local file path
      if (await file.exists()) {
        final bytes = await file.readAsBytes();

        final dir = await getApplicationDocumentsDirectory(); // App's safe folder
        final newFile = await File('${dir.path}/ai_image.png').writeAsBytes(bytes);

        log('Saved at: ${newFile.path}');

        Get.back();
        MyDialog.success('Image saved at: ${newFile.path}');
      } else {
        Get.back();
        MyDialog.error('File not found!');
      }
    } catch (e) {
      Get.back();
      MyDialog.error('Something went wrong!');
      log('downloadImageE: $e');
    }
  }


  void shareImage() async {
    try {
      // To show loading
      MyDialog.showLoadingDialog();

      log('url: $url');

      final file = File(url.value); // Use directly as File
      if (await file.exists()) {
        log('filePath: ${file.path}');

        // Hide loading
        Get.back();

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out this Amazing Image created by Ai Assistant App',
        );
      } else {
        Get.back();
        MyDialog.error('File not found!');
      }
    } catch (e) {
      // Hide loading
      Get.back();
      MyDialog.error('Something Went Wrong (Try again in sometime)!');
      log('shareImageE: $e');
    }
  }





 }