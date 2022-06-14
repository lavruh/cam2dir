import 'dart:io';

import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPreviewState extends GetxController {
  final lastPhotos = <String>["", "", "", "", ""].obs;
  final filesToPreview = <String>[].obs;
  int currentImageIndex = 0;
  SharedPreferences settings = Get.find();
  final editor = Get.put<DesignationOnImageState>(DesignationOnImageState());

  addPhoto(String url) {
    lastPhotos.insert(0, url);
    if (lastPhotos.length == 6) lastPhotos.removeLast();
  }

  saveState() async {
    await settings.setStringList("lastPhotos", lastPhotos);
  }

  loadState() {
    List<String> urls =
        settings.getStringList("lastPhotos")?.reversed.toList() ?? [];
    for (String url in urls) {
      addPhoto(url);
    }
  }

  bool checkImageFile(String path) {
    final f = File(path);
    if (f.existsSync()) {
      return true;
    }
    return false;
  }

  setFilesToPreview({required List<String> pathes, String? currentPath}) async {
    filesToPreview.clear();
    for (String path in pathes) {
      if (await File(path).exists()) {
        filesToPreview.add(path);
      }
    }
    currentImageIndex = filesToPreview.indexOf(currentPath);
    if (currentImageIndex > 0) {
      editor.loadImage(File(filesToPreview[currentImageIndex]));
    } else {
      editor.loadImage(File(filesToPreview.first));
    }
  }

  @override
  void onInit() {
    loadState();
    super.onInit();
  }

  @override
  void onClose() async {
    await saveState();
    super.onClose();
  }

  openNextImage({bool increaseIndex = true}) async {
    if (filesToPreview.isEmpty) {
      return;
    }
    bool canGoNext = false;
    await editor.hasToSavePromt(
      onConfirmCallback: () async {
        await editor.saveImage();
        canGoNext = true;
      },
      onNoCallback: () => canGoNext = true,
    );

    if (!canGoNext) {
      return;
    }

    if (increaseIndex) {
      if (currentImageIndex + 1 < filesToPreview.length) {
        currentImageIndex++;
      } else {
        currentImageIndex = 0;
      }
    } else {
      if (currentImageIndex - 1 >= 0) {
        currentImageIndex--;
      } else {
        currentImageIndex = filesToPreview.length - 1;
      }
    }

    editor.loadImage(File(filesToPreview[currentImageIndex]));
  }
}
