import 'package:camera_app/domain/photo_proc_state.dart';
import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:camera_app/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import 'package:camera_app/widgets/node/tree_node_tile.dart';
import 'package:get/get.dart';

class FsTreeView extends StatefulWidget {
  FsTreeView({key}) : super(key: key);
  final treeController = Get.find<TreeWidgetController>();
  @override
  FsTreeViewState createState() => FsTreeViewState();
}

class FsTreeViewState extends State<FsTreeView> {
  @override
  void initState() {
    widget.treeController
        .init(selectedId: Get.find<PhotoProcState>().filePath.value);
    widget.treeController.updateTree();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (widget.treeController.isInitialized) {
      content = ValueListenableBuilder<TreeViewController>(
          valueListenable: widget.treeController.treeCtrl,
          builder: (context, treeController, __) {
            return ValueListenableBuilder<TreeViewTheme>(
                valueListenable: widget.treeController.treeViewTheme,
                builder: (_, treeViewTheme, __) {
                  return Scrollbar(
                      child: TreeView(
                    controller: widget.treeController.treeController,
                    theme: treeViewTheme,
                    scrollController: widget.treeController.scrollController,
                    nodeHeight: widget.treeController.nodeHeight,
                    nodeBuilder: (_, __) => TreeNodeTile(
                      controller: widget.treeController,
                    ),
                  ));
                });
          });
    } else {
      content = const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select output directory'),
        actions: [
          ValueListenableBuilder<SortType>(
              valueListenable: widget.treeController.sortType,
              builder: (context, sortType, __) {
                late Widget icon;
                if (sortType == SortType.byName) {
                  icon = const Icon(Icons.sort_by_alpha);
                }
                if (sortType == SortType.byChange) {
                  icon = const Icon(Icons.source_outlined);
                }

                return IconButton(
                  onPressed: () {
                    widget.treeController.toggleSortType();
                    setState(() {});
                  },
                  icon: icon,
                );
              }),
          IconButton(
              onPressed: _addFolder, icon: const Icon(Icons.create_new_folder)),
        ],
      ),
      body: content,
    );
  }

  _addFolder() async {
    final state = Get.find<PhotoProcState>();
    await showDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            context: context,
            topic: "Dir name :",
            initText: "",
            callback: (val) => state.createFolder(name: val),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Name can not be empty";
              }
              return null;
            },
          );
        });
    widget.treeController.updateTree();
  }
}
