import 'dart:io';
import 'package:camera_app/domain/photo_preview_state.dart';
import 'package:camera_app/screens/photo_preview_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path_util;

const String kRootId = 'Root';

enum ExpansionButtonType { folderFile, chevron }

enum SortType { byName, byChange }

class TreeWidgetController with ChangeNotifier {
  final treeCtrl = ValueNotifier(
      TreeViewController(rootNode: TreeNode(id: "0", label: "root")));
  TreeViewController get treeController => treeCtrl.value;
  set treeController(TreeViewController val) {
    treeCtrl.value = val;
  }

  final Map<String, bool> _selectedNodes = {};
  final nodeHeight = 30.0;
  ScrollController scrollController = ScrollController();
  final treeViewTheme = ValueNotifier(const TreeViewTheme());
  final expansionButtonType = ValueNotifier(ExpansionButtonType.folderFile);
  late String _path;
  late Function outputSetter;
  Function? conditionalLunch;
  final sortType = ValueNotifier(SortType.byChange);

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  toggleSortType() {
    if (sortType.value.index + 1 == SortType.values.length) {
      sortType.value = SortType.values.first;
    } else {
      sortType.value = SortType.values[sortType.value.index + 1];
    }
    updateTree();
    notifyListeners();
  }

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

  void toggleSelection(String id, [bool? shouldSelect]) async {
    final preview = Get.find<PhotoPreviewState>();
    _selectedNodes.clear();
    if (preview.checkImageFile(id)) {
      _select(treeController.find(id)!.parent!.id);
      final dirPath = path_util.dirname(id);
      preview.setFilesToPreview(
          pathes: Directory(dirPath).listSync().map((e) => e.path).toList(),
          currentPath: id);
      await Get.to(() => const PhotoPreviewScreen());
      updateTree();
    } else {
      _select(id);
      notifyListeners();
    }
  }

  void _select(String id) {
    _selectedNodes[id] = true;
    if (id == 'root') {
      outputSetter(_path);
    } else {
      outputSetter(id);
    }
  }

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
    final rootNode = TreeNode(id: 'root', label: "root");
    buildFSTree(
      parent: rootNode,
      dir: Directory(_path),
    );
    treeController = TreeViewController(
      rootNode: rootNode,
    );

    if (_selectedNodes.isNotEmpty) {
      var n = treeController.find(_selectedNodes.keys.last);
      if (n != null) treeController.expandNode(n);
    }
    notifyListeners();
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

  void buildFSTree({required TreeNode parent, required Directory dir}) {
    final directory = dir.listSync();
    if (sortType.value == SortType.byName) {
      directory.sort((a, b) => a.path.compareTo(b.path));
    }
    if (sortType.value == SortType.byChange) {}
    List<TreeNode> filesList = [];
    for (FileSystemEntity f in directory) {
      TreeNode d = TreeNode(
        id: f.path,
        label: subFileNameFromPath(f.path),
        data: f is Directory ? true : false,
      );
      if (f is File) {
        filesList.add(d);
      }
      if (f is Directory) {
        buildFSTree(
          parent: d,
          dir: f,
        );
        parent.addChild(d);
      }
    }

    parent.addChildren(filesList);
  }

  String subFileNameFromPath(String path) {
    return path_util.basename(path);
  }
}
