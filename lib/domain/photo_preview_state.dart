import 'dart:io';

import 'package:camera_app/domain/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPreviewState extends GetxController {
  List<PhotoItem> lastPhotos = [];
  SharedPreferences settings = Get.find();
  final editor = Get.put<DesignationOnImageState>(DesignationOnImageState());

  addPhoto(String url) {
    lastPhotos.insert(0, PhotoItem(UniqueKey().toString(), url));
    if (lastPhotos.length == 6) lastPhotos.removeLast();
    update();
  }

  saveState() async {
    List<String> urls = [];
    for (PhotoItem item in lastPhotos) {
      urls.add(item.url);
    }
    await settings.setStringList("lastPhotos", urls);
  }

  loadState() {
    List<String> urls = settings.getStringList("lastPhotos") ?? [];
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

  openInEditor(BuildContext context, String path) {
    final f = File(path);
    editor.loadImage(f);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => NotesOnImageScreen()));
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

class PhotoItem {
  final String id;
  final String url;

  PhotoItem(this.id, this.url);
}
