import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

const String kRootId = 'Root';

enum ExpansionButtonType { folderFile, chevron }

class TreeWidgetController with ChangeNotifier {
  late TreeViewController treeController;
  Map<String, bool> _selectedNodes = {};
  final nodeHeight = 30.0;
  ScrollController scrollController = ScrollController();
  final treeViewTheme = ValueNotifier(const TreeViewTheme());
  final expansionButtonType = ValueNotifier(ExpansionButtonType.folderFile);

  late String _path;
  late Function outputSetter;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  TreeWidgetController({required String path, Function? pathSetCallback}) {
    _path = path;
    if (pathSetCallback != null) outputSetter = pathSetCallback;
  }

  // static AppController of(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<AppControllerScope>()!
  //       .controller;
  // }

  Future<void> init() async {
    if (_isInitialized) return;

    final rootNode = TreeNode(id: UniqueKey().toString(), label: "root");
    buildFSTree(
      parent: rootNode,
      dir: Directory(_path),
    );

    treeController = TreeViewController(
      rootNode: rootNode,
    );
    if (_selectedNodes.isNotEmpty) {
      var n = treeController.find(_selectedNodes.keys.last);
      if (n != null) treeController.expandUntil(n);
    }

    _isInitialized = true;
  }

  bool isSelected(String id) => _selectedNodes[id] ?? false;

  void toggleSelection(String id, [bool? shouldSelect]) {
    _selectedNodes.clear();
    _select(id);
    outputSetter(treeController.find(id)?.data);
    notifyListeners();
  }

  void _select(String id) => _selectedNodes[id] = true;

  void collapseAllExcept(TreeNode node) {
    treeController.collapseAll();
    treeController.expandNode(node);
    notifyListeners();
  }

  TreeNode get rootNode => treeController.rootNode;

  void scrollTo(TreeNode node) {
    final nodeToScroll = node.parent == rootNode ? node : node.parent ?? node;
    final offset = treeController.indexOf(nodeToScroll) * nodeHeight;

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void updateTheme(TreeViewTheme theme) {
    treeViewTheme.value = theme;
  }

  void updateExpansionButton(ExpansionButtonType type) {
    expansionButtonType.value = type;
  }

  @override
  void dispose() {
    treeController.dispose();
    scrollController.dispose();

    treeViewTheme.dispose();
    expansionButtonType.dispose();
    super.dispose();
  }
}

// class AppControllerScope extends InheritedWidget {
//   const AppControllerScope({
//     Key? key,
//     required this.controller,
//     required Widget child,
//   }) : super(key: key, child: child);

//   final AppController controller;

//   @override
//   bool updateShouldNotify(AppControllerScope oldWidget) => false;
// }

void buildFSTree({required TreeNode parent, required Directory dir}) {
  for (FileSystemEntity f in dir.listSync()) {
    TreeNode d = TreeNode(
      id: UniqueKey().toString(),
      label: subFileNameFromPath(f.path),
      data: f is File ? dir.path : f.path,
    );
    if (f is Directory) {
      buildFSTree(
        parent: d,
        dir: f,
      );
    }
    parent.addChild(d);
  }
}

String subFileNameFromPath(String path) {
  return path.substring(path.lastIndexOf("/") + 1);
}
