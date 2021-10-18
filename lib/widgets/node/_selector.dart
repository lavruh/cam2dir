part of 'tree_node_tile.dart';

class _NodeSelector extends StatelessWidget {
  _NodeSelector({
    required Key key,
    required this.controller,
  }) : super(key: key);
  TreeWidgetController controller;

  @override
  Widget build(BuildContext context) {
    final id = TreeNodeScope.of(context).node.id;
    final appController = controller;

    return Checkbox(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      activeColor: Colors.green.shade600,
      value: appController.isSelected(id),
      onChanged: (_) => appController.toggleSelection(id),
    );
  }
}
