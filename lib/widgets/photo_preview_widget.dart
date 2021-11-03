import 'dart:io';

import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';

class PhotoPreviewWidget extends StatelessWidget {
  PhotoPreviewWidget({Key? key}) : super(key: key);

  final state =
      Get.put<PhotoPreviewState>(PhotoPreviewState(), permanent: true);
  final editor = Get.put<DesignationOnImageState>(DesignationOnImageState());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoPreviewState>(builder: (_) {
      if (_.lastPhotos.length > 0) {
        return Card(
          elevation: 3.0,
          color: Colors.black54,
          child: Row(
            children: _.lastPhotos.map((e) {
              if (e == null) {
                return Container();
              }
              return PhotoThumbnail(
                item: e,
                onTap: () {
                  editor.loadImage(File(e.url));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NotesOnImageScreen()));
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
