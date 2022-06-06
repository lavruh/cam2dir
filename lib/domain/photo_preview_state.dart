import 'dart:io';

import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPreviewState extends GetxController {
  final lastPhotos = <String>["", "", "", "", ""].obs;
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

  openInEditor(String path) {
    final f = File(path);
    editor.loadImage(f);
    Get.to(NotesOnImageScreen());
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
}
