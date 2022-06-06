import 'dart:io';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

const String kRootId = 'Root';

enum ExpansionButtonType { folderFile, chevron }

class TreeWidgetController with ChangeNotifier {
  late TreeViewController treeController;
  final Map<String, bool> _selectedNodes = {};
  final nodeHeight = 30.0;
  ScrollController scrollController = ScrollController();
  final treeViewTheme = ValueNotifier(const TreeViewTheme());
  final expansionButtonType = ValueNotifier(ExpansionButtonType.folderFile);
  late String _path;
  late Function outputSetter;
  Function? conditionalLunch;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  TreeWidgetController({
    required String path,
    Function? pathSetCallback,
    this.conditionalLunch,
  }) {
    _path = path;
    if (pathSetCallback != null) outputSetter = pathSetCallback;
  }

  Future<void> init({String? selectedId}) async {
    if (_isInitialized) return;
    if (selectedId != null) {
      _select(selectedId);
    }
    updateTree();
    _isInitialized = true;
  }

  bool isSelected(String id) => _selectedNodes[id] ?? false;

  void toggleSelection(String id, [bool? shouldSelect]) {
    final editor = Get.find<PhotoPreviewState>();
    if (editor.checkImageFile(id)) {
      editor.openInEditor(id);
    } else {
      _selectedNodes.clear();
      _select(id);
      outputSetter(id);
      notifyListeners();
    }
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

  void updateTree() {
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
  }

  void updateTheme(TreeViewTheme theme) {
    treeViewTheme.value = theme;
  }

  void updateExpansionButton(ExpansionButtonType type) {
    expansionButtonType.value = type;
  }

  @override
  void dispose() {
    _isInitialized = false;
    treeController.dispose();
    scrollController.dispose();

    treeViewTheme.dispose();
    expansionButtonType.dispose();
    super.dispose();
  }
}

void buildFSTree({required TreeNode parent, required Directory dir}) {
  for (FileSystemEntity f in dir.listSync()) {
    TreeNode d = TreeNode(
      id: f.path,
      label: subFileNameFromPath(f.path),
      data: f is Directory ? true : false,
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
