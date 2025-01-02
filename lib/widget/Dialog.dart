// delete_dialog.dart
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:days/sql/sql_c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../l10n/l10n.dart';
import '../pages/common.dart';
import '../pages/commonnote.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteData(context, id, dbHelper, onDelete);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(40), // Make button full width
                ),
                child: Text(S.of(context).Delete),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditcommon(id: id),
                    ),
                  ).then((value) {
                    onEdit(); // Refresh data
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(40), // Make button full width
                ),
                child: Text(S.of(context).Edit),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(40), // Make button full width
                ),
                child: Text(S.of(context).Cancel),
              ),
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
          title: Text(S.of(context).AddTag),
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
              child: Text(S.of(context).Yes),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteData2(context, id, dbHelper, onDelete);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(40), // Make button full width
                ),
                child: Text(S.of(context).Delete),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(40), // Make button full width
                ),
                child: Text(S.of(context).Edit),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(40), // Make button full width
                ),
                child: Text(S.of(context).Cancel),
              ),
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
          title: Text(S.of(context).DownloadCompleted),
          content: Text(S.of(context).DownloadFinInfo),
          actions: [
            ElevatedButton(
              child: Text(S.of(context).Later),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(S.of(context).Open),
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
      {required String value,
      required String la,
      required String size,
      required AppName,
      required String formattedSize}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).UpdateAPP),
            content: Text(
                "${S.of(context).NewVer} $value \n${S.of(context).AppSz} : ${size}MB\n${la}\n是否更新到$value版本！"),
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
                  showDownloadProgress(context, value, AppName, formattedSize);
                },
              )
            ],
          );
        });
  }
}

class ShareQrCode {
  static final GlobalKey _repaintBoundaryKey = GlobalKey();
  static Future<void> saveToGallery(BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        print('Error: Unable to capture the widget.');
        return;
      }

      // Convert to Image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      Future<bool> checkPermission() async {
        if (Platform.isAndroid) {
          final status = await Permission.storage.status;
          final status1 = await Permission.manageExternalStorage.isGranted;
          if (status != PermissionStatus.granted ||
              status1 != Permission.manageExternalStorage.isGranted) {
            final result = await Permission.storage.request();
            final result1 = await Permission.manageExternalStorage.request();
            if (result == PermissionStatus.granted ||
                result1 == PermissionStatus.granted) {
              return true;
            }
          } else {
            return true;
          }
        }
        return true;
      }

      // Request storage permission
      if (await checkPermission()) {
        // Save to Pictures directory
        var directory = Directory('/storage/emulated/0/Pictures');
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Pictures/days');
        } else if (Platform.isWindows) {
          // 获取当前可执行文件的目录
          String executablePath = Platform.resolvedExecutable;
          String executableDir = path.dirname(executablePath);
          directory = Directory('$executableDir/Pictures');
        }
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final filePath =
            '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(filePath);
        await file.writeAsBytes(pngBytes);

        print('Image saved to gallery: $filePath');
      } else {
        print('Permission denied.');
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  static void showShareQrCodeDialog(
      BuildContext context, Map<String, dynamic>? dataList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: RepaintBoundary(
            key: _repaintBoundaryKey,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(dataList?['name'] ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    height: 320,
                    child: Center(
                      child: QrImageView(
                        data: dataList.toString(),
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // print(dataList.toString());
                            saveToGallery(context);
                          },
                          child: Text(S.of(context).Save)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).Cancel),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
