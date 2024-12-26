import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BackupDate {
  late String localPath;
  final sqlfile = 'appdata.db';
  final windowsSrc = 'bin/db';
  final AndroidPath = '/storage/emulated/0/Download/';
  final WindowsPath = 'C:/Users/Public/Downloads/';
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
        //文件复制
        File(path).copy('${AndroidPath}/$sqlfile');
      } else {
        String executablePath = Platform.resolvedExecutable;
        String executableDir = executablePath;
        String databasePath = '$executableDir/$windowsSrc/$sqlfile';
        File(databasePath).copy('$WindowsPath/$sqlfile');
      }
    } catch (e) {
      print(e);
    }
  }
}
