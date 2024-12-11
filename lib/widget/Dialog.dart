// delete_dialog.dart
import 'package:days/sql/sql_c.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../generated/l10n.dart';
import '../pages/common.dart';
import '../pages/commonnote.dart';
import '../pages/edit.dart';

class DeleteEditAll {
  static void showDeleteEditAllDialog(BuildContext context, int id,
      sqlite dbHelper, Function onDelete, Function onEdit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).EditDelete),
          content: Text(S.of(context).ThisUndone),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteData(context, id, dbHelper, onDelete);
              },
              child: Text(S.of(context).Delete),
            ),
            ElevatedButton(
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
              child: Text(S.of(context).Edit),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).Cancel),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _deleteData(
    BuildContext context,
    int id,
    sqlite dbHelper,
    Function onDelete,
  ) async {
    await dbHelper.deleteData(id);
    onDelete(); // 调用外部传入的回调函数刷新数据
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(S.of(context).DeF)),
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
          title:  Text(S.of(context).AddTag),
          content: TextField(
            controller: _tagController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).Cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_tagController.text.isNotEmpty) {
                  // 将新标签传递回调用页面
                  onTagAdded(_tagController.text);
                  Navigator.pop(context);
                }
              },
              child:  Text(S.of(context).Yes),
            ),
          ],
        );
      },
    );
  }
}

class DeleteEditNote {
  static void showDeleteNoteDialog(BuildContext context, int id,
      sqlite dbHelper, Function onDelete, Function Loaddata) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).EditDelete),
          content: Text(S.of(context).ThisUndone),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteData2(context, id, dbHelper, onDelete);
              },
              child: Text(S.of(context).Delete),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotePage(id: id),
                  ),
                ).then((value) {
                  Loaddata(); // 刷新数据
                });
              },
              child: Text(S.of(context).Edit),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).Cancel),
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
       SnackBar(content: Text(S.of(context).DeF)),
    );
  }
}

class UpdateComCompletionDialog {
  static void UpdateComp(String filePath, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(S.of(context).DownloadCompleted),
          content:  Text(S.of(context).DownloadFinInfo),
          actions: [
            ElevatedButton(
              child:  Text(S.of(context).Later),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child:  Text(S.of(context).Open),
              onPressed: () async {
                Navigator.pop(context);
                await OpenFilex.open(filePath,
                    type: "application/vnd.android.package-archive");
              },
            ),
          ],
        );
      },
    );
  }
}

class ShowUpdateDialog {
  static void showUpdateDialog(
      BuildContext context, Function showDownloadProgress,
      {required String value, required String la}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text(S.of(context).UpdateAPP),
            content: Text("发现新的版本 $value \n新版本${la} \n是否更新到$value版本！"),
            actions: <Widget>[
              ElevatedButton(
                child: Text(S.of(context).Cancel),
                onPressed: () {
                  Navigator.pop(context, 'Cancle');
                },
              ),
              ElevatedButton(
                child: Text(S.of(context).Yes),
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                  // _downLoad(value);
                  showDownloadProgress(context, value);
                },
              )
            ],
          );
        });
  }
}
