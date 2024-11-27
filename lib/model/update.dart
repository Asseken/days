import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class Getpackgeinfo {
  static String appName = "";
  static String packageName = "";
  static String appversion = "";
  static String buildNumber = "";
  //从GitHub中获取更新的软件
  static Future<void> githubrelease(BuildContext context) async {
    //获取GitHub的API 判断是否有新的版本，判断version是否大于github的tag_name有则下载。
    var url = "https://api.github.com/repos/Asseken/days-test/releases/latest";
    var response = await Dio().get(url);
    var data = response.data;
    var version = data["tag_name"];
    var latestReleasesNnotes = data["body"];
    await getPackageInfo();
    if (appversion != version) {
      //下载新的版本
      // _downLoad();
      // getPackageInfo();
      dialog(context, value: version,la:latestReleasesNnotes);
      // print("本地版本:$appversion,远端版本:$version");
    } else {
      // print("已经是最新版本");
    }
  }

  static Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status ;
      final status1= await Permission.manageExternalStorage.isGranted;
      if (status != PermissionStatus.granted ||status1!=Permission.manageExternalStorage.isGranted) {
        final result = await Permission.storage.request();
        final result1 = await Permission.manageExternalStorage.request();
        if (result == PermissionStatus.granted || result1==PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  static Future<void> getapppath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    Directory? directory = await getExternalStorageDirectory();
    String storageDirectory = directory!.path;

    print("tempPath:$tempPath");
    print("appDocDir:$appDocPath");
    print("StorageDirectory:$storageDirectory");
  }

  static Future<void> dialog(BuildContext context,
      {required String value,required String la}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("更新APP提示!"),
            content: Text("发现新的版本 $value \n新版本${la} \n是否更新到$value版本！"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("否"),
                onPressed: () {
                  Navigator.pop(context, 'Cancle');
                },
              ),
              ElevatedButton(
                child: const Text("是"),
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                  _downLoad(value);
                },
              )
            ],
          );
        });
  }

  static Future<void> _downLoad(value) async {
    var permission = await _checkPermission();
    if (permission) {
      final directory = await getExternalStorageDirectory();
      String localPath = directory!.path;
      String appName = "test.apk";
      String savePath = "$localPath/$appName";

      String apkUrl =
          "https://github.com/Asseken/days-test/releases/download/$value/app-release.apk";

      ///参数一 文件的网络储存URL
      ///参数二 下载的本地目录文件
      ///参数三 下载监听
      Dio dio = Dio();
      await dio.download(apkUrl, savePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          ///当前下载的百分比例
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      });
      print(savePath);
      await OpenFilex.open(savePath,
          type: "application/vnd.android.package-archive");
    } else {
      print("没有权限");
    }
  }

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
