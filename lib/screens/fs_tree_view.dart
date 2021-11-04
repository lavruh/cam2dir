import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import 'package:camera_app/widgets/node/tree_node_tile.dart';
import 'package:get/get.dart';

class FsTreeView extends StatefulWidget {
  FsTreeView({key}) : super(key: key);

  final treeController = Get.find<TreeWidgetController>();

  @override
  _FsTreeViewState createState() => _FsTreeViewState();
}

class _FsTreeViewState extends State<FsTreeView> {
  @override
  void initState() {
    widget.treeController.updateTree();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.treeController.init();

    Widget? content;
    if (widget.treeController.isInitialized) {
      content = ValueListenableBuilder<TreeViewTheme>(
        valueListenable: widget.treeController.treeViewTheme,
        builder: (_, treeViewTheme, __) {
          return Scrollbar(
            isAlwaysShown: false,
            child: TreeView(
              controller: widget.treeController.treeController,
              theme: treeViewTheme,
              scrollController: widget.treeController.scrollController,
              nodeHeight: widget.treeController.nodeHeight,
              nodeBuilder: (_, __) => TreeNodeTile(
                controller: widget.treeController,
              ),
            ),
          );
        },
      );
    } else {
      content = const CircularProgressIndicator();
    }

    return Scaffold(
      body: content,
    );
  }
}
