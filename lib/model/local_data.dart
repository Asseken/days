import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static setData(String key, dynamic value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, json.encode(value));
  }

  static getData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString(key);
    return json.decode(data!);
  }

  static removeData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}

class StorageForBool {
  static setData(String key, dynamic value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // 直接存储布尔值，不需要 json 编码
    pref.setBool(key, value);
  }

  static Future<bool> getData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // 直接获取布尔值，不需要 json 解码
    return pref.getBool(key) ?? false; // 默认返回 false
  }

  static removeData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}

class StorageLa {
  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
