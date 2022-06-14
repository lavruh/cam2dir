import 'dart:io';

import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/screens/photo_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoPreviewWidget extends StatelessWidget {
  const PhotoPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PhotoPreviewState>(builder: (_) {
      Widget child = Container();
      if (_.lastPhotos.isNotEmpty) {
        child = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _.lastPhotos.map((url) {
            if (!_.checkImageFile(url)) {
              return const SizedBox(height: 60, width: 60);
            }
            return PhotoThumbnail(
              item: url,
              onTap: () {
                _.setFilesToPreview(pathes: _.lastPhotos);
                Get.to(() => const PhotoPreviewScreen());
              },
            );
          }).toList(),
        );
      }
      return SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: child,
      );
    });
  }
}

class PhotoThumbnail extends StatelessWidget {
  const PhotoThumbnail({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final String item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
            tag: item,
            child: Image.file(
              File(item),
              height: 60.0,
              width: 60.0,
            )),
      ),
    );
  }
}
