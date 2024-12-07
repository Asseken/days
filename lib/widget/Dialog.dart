// delete_dialog.dart
import 'package:days/sql/sql_c.dart';
import 'package:flutter/material.dart';

import '../pages/common.dart';
import '../pages/edit.dart';

class DeleteEditAll {
  static void showDeleteEditAllDialog(BuildContext context, int id,
      sqlite dbHelper, Function onDelete, Function onEdit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("需要编辑还是删除？"),
          content: const Text("此操作无法撤销！"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // print("---------------$id");
                // Navigator.push(context, MaterialPageRoute(builder: (context) => editcunday(id: id)));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditcommon(id: id),
                  ),
                ).then((value) {
                  onEdit(); // 刷新数据
                });
              },
              child: const Text("编辑"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteData(context, id, dbHelper, onDelete);
              },
              child: const Text("删除"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("取消"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _deleteData(
      BuildContext context, int id, sqlite dbHelper, Function onDelete) async {
    await dbHelper.deleteData(id);
    onDelete(); // 调用外部传入的回调函数刷新数据
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("删除成功！")),
    );
  }
}

class DeleteDialog {
  static void showDeleteDialog(
      BuildContext context, int id, sqlite dbHelper, Function onDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("确认删除？"),
          content: const Text("此操作无法撤销！"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteData(context, id, dbHelper, onDelete);
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _deleteData(
      BuildContext context, int id, sqlite dbHelper, Function onDelete) async {
    await dbHelper.deleteData(id);
    onDelete(); // 调用外部传入的回调函数刷新数据
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("删除成功！")),
    );
  }
}

class Edit {
  static void showEditDialog(
      BuildContext context, int id, sqlite dbHelper, Function onEdit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("确认修改？"),
          content: const Text("此操作无法撤销！"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // print("---------------$id");
                // Navigator.push(context, MaterialPageRoute(builder: (context) => editcunday(id: id)));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditcommon(id: id),
                  ),
                ).then((value) {
                  onEdit(); // 刷新数据
                });
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }
}

class AddNoteTag {
  static void showAddNoteTagDialog(
      BuildContext context, Function(String) onTagAdded) {
    final TextEditingController _tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("添加标签"),
          content: TextField(
            controller: _tagController,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () async {
                if (_tagController.text.isNotEmpty) {
                  // 将新标签传递回调用页面
                  onTagAdded(_tagController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }
}

class DeleteNote {
  static void showDeleteNoteDialog(
      BuildContext context, int id, sqlite dbHelper, Function onDelete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("确认删除？"),
          content: const Text("此操作无法撤销！"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteData2(context, id, dbHelper, onDelete);
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _deleteData2(
      BuildContext context, int id, sqlite dbHelper, Function onDelete) async {
    await dbHelper.deleteData2(id);
    onDelete(); // 调用外部传入的回调函数刷新数据
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("删除成功！")),
    );
  }
}
