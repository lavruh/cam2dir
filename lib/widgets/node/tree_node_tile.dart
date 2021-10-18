import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:camera_app/domain/tree_widget_controller.dart';

part '_selector.dart';
part '_title.dart';

const Color _kDarkBlue = Color(0xFF1565C0);

const RoundedRectangleBorder kRoundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class TreeNodeTile extends StatefulWidget {
  TreeNodeTile({Key? key, required this.controller}) : super(key: key);

  TreeWidgetController controller;

  @override
  _TreeNodeTileState createState() => _TreeNodeTileState();
}

class _TreeNodeTileState extends State<TreeNodeTile> {
  @override
  Widget build(BuildContext context) {
    final appController = widget.controller;
    final nodeScope = TreeNodeScope.of(context);

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
              LinesWidget(),
              NodeWidgetLeadingIcon(useFoldersOnly: true),
              const SizedBox(width: 8),
              Expanded(
                  child: _NodeTitle(
                controller: widget.controller,
              )),
            ],
          );
        },
      ),
    );
  }
}
