import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPreviewState extends GetxController {
  List<PhotoItem> lastPhotos = [];
  SharedPreferences settings = Get.find();

  addPhoto(String url) {
    lastPhotos.insert(0, PhotoItem(UniqueKey().toString(), url));
    if (lastPhotos.length == 6) lastPhotos.removeLast();
    // lastPhotos.add();
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
