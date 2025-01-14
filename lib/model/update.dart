import 'package:days/widget/Dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/l10n.dart';

class Getpackgeinfo {
  static String appName = "";
  static String packageName = "";
  static String appversion = "";
  static String buildNumber = "";
  //从GitHub中获取更新的软件
  static Future<void> githubrelease(BuildContext context) async {
    //获取GitHub的API 判断是否有新的版本，判断version是否大于github的tag_name有则下载。
    var url = "https://api.github.com/repos/Asseken/days/releases/latest";
    var response = await Dio().get(url);
    var data = response.data;
    var version = data["tag_name"];
    var AppName = data["assets"][0]["name"];
    //保留两位小数
    double PackageSize = data["assets"][0]["size"] / 1024 / 1024;
    String formattedSize = PackageSize.toStringAsFixed(2);
    var latestReleasesNnotes = data["body"];
    await getPackageInfo();
    if (appversion != version) {
      //下载新的版本
      ShowUpdateDialog.showUpdateDialog(context, _showDownloadProgress,
          value: version,
          la: latestReleasesNnotes,
          size: formattedSize,
          AppName: AppName,
          formattedSize: formattedSize);
      // print("本地版本:$appversion,远端版本:$version");
    } else {
      // print("已经是最新版本");
    }
  }

  static Future<void> getapppath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    Directory? directory = await getExternalStorageDirectory();
    String storageDirectory = directory!.path;

    // print("tempPath:$tempPath");
    // print("appDocDir:$appDocPath");
    // print("StorageDirectory:$storageDirectory");
  }

  static Future<void> _showDownloadProgress(BuildContext context, String value,
      String AppName, String formattedSize) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DownloadProgressDialog(
              value: value, AppName: AppName, formattedSize: formattedSize);
        });
  }

  // static Future<void> _downLoad(value) async {
  //   var permission = await _checkPermission();
  //   if (permission) {
  //     final directory = await getExternalStorageDirectory();
  //     String localPath = directory!.path;
  //     String appName = "test.apk";
  //     String savePath = "$localPath/$appName";
  //
  //     String apkUrl =
  //         "https://github.com/Asseken/days-test/releases/download/$value/app-release.apk";
  //
  //     ///参数一 文件的网络储存URL
  //     ///参数二 下载的本地目录文件
  //     ///参数三 下载监听
  //     Dio dio = Dio();
  //     await dio.download(apkUrl, savePath,
  //         onReceiveProgress: (received, total) {
  //       if (total != -1) {
  //         ///当前下载的百分比例
  //         print((received / total * 100).toStringAsFixed(0) + "%");
  //       }
  //     });
  //     print(savePath);
  //     await OpenFilex.open(savePath,
  //         type: "application/vnd.android.package-archive");
  //   } else {
  //     print("没有权限");
  //   }
  // }

  static Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // 提取应用的相关信息
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    appversion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    // 打印应用信息
    // print("App Name: $appName");
    // print("Package Name: $packageName");
    // print("Version: $appversion");
    // print("Build Number: $buildNumber");

    // 如果需要返回信息，可考虑将信息存储在 Map 或其他结构中返回
    // return {
    //   'appName': appName,
    //   'packageName': packageName,
    //   'version': version,
    //   'buildNumber': buildNumber,
    // };
  }
}

class DownloadProgressDialog extends StatefulWidget {
  final String value;
  final String AppName;
  final String formattedSize;
  const DownloadProgressDialog(
      {Key? key,
      required this.value,
      required this.AppName,
      required this.formattedSize})
      : super(key: key);

  @override
  _DownloadProgressDialogState createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double progress = 0.0;
  String speed = "0 KB/s";
  String status = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在这里设置本地化的状态
    status = S.of(context).Download;
  }

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    var permission = await _checkPermission();
    if (!permission) {
      setState(() {
        status = S.of(context).DownloadErrorPer;
      });
      return;
    }
    String savePath = await _getSavePath();

    String apkUrl =
        "https://github.com/Asseken/days-test/releases/download/${widget.value}/${widget.AppName}";

    Dio dio = Dio();
    int lastReceived = 0;
    int lastTime = DateTime.now().millisecondsSinceEpoch;

    await dio.download(apkUrl, savePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        int now = DateTime.now().millisecondsSinceEpoch;
        int elapsed = now - lastTime;

        if (elapsed >= 1000) {
          int diff = received - lastReceived;
          double speedInKB = diff / elapsed * 1000 / 1024;

          setState(() {
            progress = received / total;
            speed = _formatSize(speedInKB) + "/s";
            status = S.of(context).Download;
          });

          lastReceived = received;
          lastTime = now;
        }
      }
    }).then((_) {
      setState(() {
        status = S.of(context).DownloadCompleted;
      });
      Navigator.pop(context); // 关闭下载进度弹窗

      // 显示下载完成提示
      // _showCompletionDialog(context, savePath);
      UpdateComCompletionDialog.UpdateComp(savePath, context);
      // OpenFilex.open(savePath, type: "application/vnd.android.package-archive");
    }).catchError((error) {
      setState(() {
        status = S.of(context).DownloadFailed;
      });
    });
  }

  Future<String> _getSavePath() async {
    Directory directory;

    if (Platform.isAndroid) {
      // Android
      directory = (await getExternalStorageDirectory())!;
    } else if (Platform.isWindows) {
      // Windows
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError("不支持的操作系统");
    }

    String localPath = directory.path;
    String appName = "test.apk";
    return "$localPath/$appName";
  }

  String _formatSize(double sizeInKB) {
    if (sizeInKB < 1024) {
      return "${sizeInKB.toStringAsFixed(1)} KB";
    } else {
      return "${(sizeInKB / 1024).toStringAsFixed(1)} MB";
    }
  }

  String _formatSize1(double progress) {
    return progress.toStringAsFixed(2);
  }

  static Future<bool> _checkPermission() async {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).DownloadProgress),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 10),
          Text("${(progress * 100).toStringAsFixed(0)}%"),
          Text("${_formatSize1(progress * 10)}MB/${widget.formattedSize}MB"),
          Text("${S.of(context).speed}: $speed"),
          Text("${S.of(context).status}: $status"),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text(S.of(context).Cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
