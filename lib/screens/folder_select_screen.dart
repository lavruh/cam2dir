import 'package:camera_app/di.dart';
import 'package:camera_app/widgets/filesys_tree_widget.dart';
import 'package:flutter/material.dart';

class FolderSelectScreen extends StatelessWidget {
  const FolderSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FileSysTreeWidget(
        camera.basePath,
        selectedDirPath: camera.filePath,
      ),
    );
  }
}
