import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import 'package:camera_app/widgets/node/tree_node_tile.dart';

class FsTreeView extends StatefulWidget {
  FsTreeView({
    key,
    @required this.treeController,
  }) : super(key: key);

  var treeController;

  @override
  _FsTreeViewState createState() => _FsTreeViewState();
}

class _FsTreeViewState extends State<FsTreeView> {
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
