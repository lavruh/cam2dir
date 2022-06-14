import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/widgets/custom_gesture_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Get.find<PhotoPreviewState>();
    return RawGestureDetector(gestures: {
      HorizontalSwipeGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          HorizontalSwipeGestureRecognizer>(
        () => HorizontalSwipeGestureRecognizer(
          screenWidth: MediaQuery.of(context).size.width,
          onSwipeLeft: state.openNextImage,
          onSwipeRight: () => state.openNextImage(increaseIndex: false),
        ),
        (HorizontalSwipeGestureRecognizer instance) {},
      )
    }, child: const NotesOnImageScreen());
  }
}
