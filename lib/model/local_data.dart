import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class Storage{
  static setData(String key,dynamic value) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString(key, json.encode(value));
  }
  static getData(String key) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String? data=pref.getString(key);
    return json.decode(data!);
  }
  static removeData(String key) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}