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
            controller.toggleSelection(nodeScope.node.id);
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
