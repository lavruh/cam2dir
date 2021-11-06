import 'dart:io';

import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO make smaller prev photos

class PhotoPreviewWidget extends StatelessWidget {
  PhotoPreviewWidget({Key? key}) : super(key: key);

  final state =
      Get.put<PhotoPreviewState>(PhotoPreviewState(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoPreviewState>(builder: (_) {
      if (_.lastPhotos.isNotEmpty) {
        return Card(
          elevation: 3.0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _.lastPhotos.map((e) {
              if (!_.checkImageFile(e.url)) {
                return const Icon(
                  Icons.photo_camera,
                  color: Colors.grey,
                );
              }
              return PhotoThumbnail(
                item: e,
                onTap: () {
                  _.openInEditor(context, e.url);
                },
              );
            }).toList(),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

class PhotoThumbnail extends StatelessWidget {
  const PhotoThumbnail({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final PhotoItem item;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
            tag: item.id,
            child: Image.file(
              File(item.url),
              height: 60.0,
              width: 60.0,
            )),
      ),
    );
  }
}
