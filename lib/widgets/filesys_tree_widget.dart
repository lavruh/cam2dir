import 'dart:io';
import 'package:camera_app/di.dart';
import 'package:flutter/material.dart';

class FileSysTreeWidget extends StatefulWidget {
  Directory root = Directory("");
  Directory selectedDir = Directory('');
  List<FileSystemEntity> fsTree = [];

  FileSysTreeWidget(String rootPath, {String? selectedDirPath, Key? key})
      : super(key: key) {
    root = Directory(rootPath);
    if (!root.existsSync() || root is! Directory) {
      throw Exception("Root path is not a directory");
    }
    if (selectedDirPath != null) {
      selectedDir = Directory(selectedDirPath);
    } else {
      selectedDir = root;
    }
    fsTree = [root];
  }

  @override
  State<FileSysTreeWidget> createState() => _FileSysTreeWidgetState();
}

class _FileSysTreeWidgetState extends State<FileSysTreeWidget> {
  setSelectedDir(Directory d) {
    setState(() {
      widget.selectedDir = d;
    });
    camera.setFilePath(d.path);
  }

  bool isSelected(FileSystemEntity e) {
    return widget.selectedDir.path.contains(e.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FractionallySizedBox(
          widthFactor: 0.99,
          child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5.0,
                    children: [
                      Text(
                        "Selected:",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(widget.selectedDir.path.replaceAll(
                        widget.root.path,
                        subFileNameFromPath(widget.root.path),
                      )),
                    ],
                  ))),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                FileSysEntryWidget(
              widget.fsTree[index],
              selectedCallback: setSelectedDir,
              isSelected: isSelected,
            ),
            itemCount: widget.fsTree.length,
          ),
        ),
      ],
    );
  }
}

String subFileNameFromPath(String path) {
  return path.substring(path.lastIndexOf("/") + 1);
}

class FileSysEntryWidget extends StatelessWidget {
  FileSystemEntity entity;
  Function? selectedCallback;
  Function? isSelected;

  FileSysEntryWidget(this.entity, {this.selectedCallback, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return buildTile(entity);
  }

  Widget buildTile(FileSystemEntity e) {
    bool selected = isSelected != null ? isSelected!(e) : false;
    if (e is Directory) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Card(
          elevation: 3.0,
          child: ExpansionTile(
            initiallyExpanded: selected,
            onExpansionChanged: (bool isOpen) {
              if (isOpen && selectedCallback != null) selectedCallback!(e);
            },
            title: Text(subFileNameFromPath(e.path)),
            children: e.listSync().map((f) => buildTile(f)).toList(),
          ),
        ),
      );
    }
    return ListTile(
      title: Text(subFileNameFromPath(e.path)),
    );
  }
}
