import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

import '../l10n/l10n.dart';

class BackupDate {
  late String localPath;
  final sqlfile = 'appdata.db';
  final windowsSrc = 'bin/db';
  final AndroidPath = '/storage/emulated/0/Download/days';
  final WindowsPath = 'C:/Users/Public/DaysBackup';
//文件存在检查
  Future<void> ensureDirectoryExists(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  //备份数据
  Future<void> backupDatabase(context) async {
    try {
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        localPath = directory!.path;
        var databasesPath = localPath;
        String path = "$databasesPath/$sqlfile";
        var database = await openDatabase(path);
        await database.close();
        await ensureDirectoryExists(AndroidPath);
        //文件复制
        await File(path).copy('${AndroidPath}/$sqlfile');
      } else {
        String executablePath = Platform.resolvedExecutable;
        String executableDir = path.dirname(executablePath);
        String databasePath = '$executableDir/$windowsSrc/$sqlfile';
        await ensureDirectoryExists(WindowsPath);
        await File(databasePath).copy('$WindowsPath/$sqlfile');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).BackupsS)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).BackupsF}${e.toString()}")),
      );
    }
  }

  //恢复数据
  Future<void> restoreDatabase(context) async {
    try {
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        localPath = directory!.path;
        var databasesPath = localPath;
        String path = "$databasesPath/$sqlfile";
        var database = await openDatabase(path);
        await database.close();
        await ensureDirectoryExists(AndroidPath);
        //文件复制
        await File('${AndroidPath}/$sqlfile').copy(path);
      } else {
        String executablePath = Platform.resolvedExecutable;
        String executableDir = path.dirname(executablePath);
        String databasePath = '$executableDir/$windowsSrc/$sqlfile';
        await ensureDirectoryExists(WindowsPath);
        await File('$WindowsPath/$sqlfile').copy(databasePath);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).RestoreS)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).RestoreF}${e.toString()}")),
      );
    }
  }
}
