import 'package:camera_app/domain/tree_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class NodeTitle extends StatelessWidget {
  const NodeTitle({Key? key, required this.controller}) : super(key: key);

  final TreeWidgetController controller;

  @override
  Widget build(BuildContext context) {
    final appController = controller;
    final nodeScope = TreeNodeScope.of(context);

    return AnimatedBuilder(
      animation: appController,
      builder: (_, __) {
        final textStyle = appController.isSelected(nodeScope.node.id)
            ? Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Colors.green.shade500,
                  fontWeight: FontWeight.w500,
                )
            : Theme.of(context).textTheme.subtitle1;
        return GestureDetector(
          onTap: () {
            final id = nodeScope.node.id;
            controller.toggleSelection(id);
          },
          child: Text(
            nodeScope.node.label,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
