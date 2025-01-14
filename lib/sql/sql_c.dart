import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class sqlite {
  final sqlfile = 'appdata.db';
  final table = 'cuntday';
  final table2 = 'Note';
  final windowsSrc = 'bin/db';
  Future<void> initializeDatabase() async {
    if (!Platform.isAndroid) {
      // 初始化 FFI
      sqfliteFfiInit();
      // 设置数据库工厂
      databaseFactory = databaseFactoryFfi;
    }
  }

  openDb() async {
    // final directory = await getExternalStorageDirectory();
    // String localPath = directory!.path;
    String localPath;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      localPath = directory!.path;
      var databasesPath = localPath;
      String path = "$databasesPath/$sqlfile";
      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
    } else {
      // final directory = await getApplicationDocumentsDirectory();
      // localPath = directory.path;
      // 获取当前可执行文件的目录
      String executablePath = Platform.resolvedExecutable;
      String executableDir = path.dirname(executablePath);

      // 构建数据库路径
      String databasePath = path.join(executableDir, windowsSrc, sqlfile);

      // 确保目录存在
      Directory(path.dirname(databasePath)).createSync(recursive: true);
      var db =
          await openDatabase(databasePath, version: 1, onCreate: _onCreate);
      return db;
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT, 
        time TEXT,
        description TEXT,
        Typedes TEXT,
        StopTime TEXT,
        StopCs INTEGER DEFAULT 0,
        value INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE $table2 (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT,
        subtitle TEXT,
        time TEXT,
        Tag TEXT,
        imagesrc TEXT,
        description TEXT,
        music TEXT,
        value INTEGER
      )
    ''');
  }

//插入数据
  Future<void> insertData(Map<String, dynamic> data) async {
    final db = await openDb();
    await db.insert(table, data);
  }

//插入数据
  Future<void> insertData2(Map<String, dynamic> data) async {
    final db = await openDb();
    await db.insert(table2, data);
  }

  //获取全部数据
  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await openDb();
    return await db.query(table);
  }

  //获取全部数据
  Future<List<Map<String, dynamic>>> getAllData2() async {
    final db = await openDb();
    return await db.query(table2);
  }

//搜索数据
  Future<List<Map<String, dynamic>>> searchData(String name) async {
    final db = await openDb();
    return await db.query(table, where: 'name = ?', whereArgs: [name]);
  }

//搜索数据
  Future<List<Map<String, dynamic>>> searchData2(String title) async {
    final db = await openDb();
    return await db.query(table2, where: 'title = ?', whereArgs: [title]);
  }

  //获取table2的全部tag数据
  Future<List<Map<String, dynamic>>> getAllTag() async {
    final db = await openDb();
    return await db.query(table2, columns: ['Tag']);
  }


  //获取的单挑数据
  Future<Map<String, dynamic>> getOneData(int id) async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps[0];
  }

  //获取的单挑数据
  Future<Map<String, dynamic>> getOneData2(int id) async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps =
        await db.query(table2, where: 'id = ?', whereArgs: [id]);
    return maps[0];
  }

//删除数据
  Future<void> deleteData(int id) async {
    final db = await openDb();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  //删除数据
  Future<void> deleteData2(int id) async {
    final db = await openDb();
    await db.delete(table2, where: 'id = ?', whereArgs: [id]);
  }

  //修改数据
  Future<void> updateData(Map<String, dynamic> data) async {
    final db = await openDb();
    await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  //修改数据
  Future<void> updateData2(Map<String, dynamic> data) async {
    final db = await openDb();
    await db.update(table2, data, where: 'id = ?', whereArgs: [data['id']]);
  }
}
