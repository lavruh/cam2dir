import 'package:camera_app/widgets/node/tree_node_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:camera_app/domain/tree_widget_controller.dart';

const RoundedRectangleBorder kRoundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class TreeNodeTile extends StatefulWidget {
  const TreeNodeTile({Key? key, required this.controller}) : super(key: key);
  final TreeWidgetController controller;

  @override
  TreeNodeTileState createState() => TreeNodeTileState();
}

class TreeNodeTileState extends State<TreeNodeTile> {
  @override
  Widget build(BuildContext context) {
    final appController = widget.controller;
    final nodeScope = TreeNodeScope.of(context);
    final bool isFolder = nodeScope.node.data as bool;

    return InkWell(
      onTap: () {
        appController.collapseAllExcept(nodeScope.node);
      },
      onLongPress: () => appController.toggleSelection(nodeScope.node.id),
      child: ValueListenableBuilder<ExpansionButtonType>(
        valueListenable: appController.expansionButtonType,
        builder: (context, ExpansionButtonType buttonType, __) {
          return Row(
            children: [
              const LinesWidget(),
              NodeWidgetLeadingIcon(
                useFoldersOnly: false,
                leafIcon: isFolder == true
                    ? const Icon(Icons.folder_open)
                    : const Icon(Icons.image),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: NodeTitle(
                controller: widget.controller,
              )),
            ],
          );
        },
      ),
    );
  }
}
