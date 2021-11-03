part of 'tree_node_tile.dart';

class _NodeTitle extends StatelessWidget {
  _NodeTitle({Key? key, required this.controller}) : super(key: key);

  TreeWidgetController controller;

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
            if (controller.conditionalLunch != null) {
              controller
                  .conditionalLunch!(controller.treeController.find(id)?.data);

              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotesOnImageScreen()));
            }
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
