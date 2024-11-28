import 'package:flutter/material.dart';

import '../model/local_data.dart';

class AppTheme {
  /// 亮色主题配置
  static ThemeData lightTheme = ThemeData(
    // 主要颜色配置
    primaryColor: Colors.blue,

    // 颜色方案配置（用于按钮、AppBar等）
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 208, 188, 242),
      secondary: const Color.fromARGB(255, 228, 188, 228),
      surface: Colors.white,
      background: Colors.grey[100]!,
      error: Colors.red,
    ),

    // 应用程序栏主题
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 181, 234, 202),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // 文本主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
    ),

    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    //TEXT BUTTON
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  /// 暗色主题配置
  static ThemeData darkTheme = ThemeData(
    // 主要颜色配置
    primaryColor: Colors.deepPurple,

    // 颜色方案配置（用于按钮、AppBar等）
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple,
      secondary: Colors.deepPurpleAccent,
      surface: Colors.grey[900]!,
      background: Colors.black,
      error: Colors.redAccent,
    ),

    // 应用程序栏主题
    appBarTheme: const AppBarTheme(
      color: Colors.deepPurple,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // 文本主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: const TextStyle(fontSize: 16, color: Colors.white70),
    ),

    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white30),
      ),
    ),

    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    //TEXT BUTTON
    textButtonTheme: TextButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

  );
}

/// 主题切换提供者
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadThemeFromStorage();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    _saveThemeToStorage();
    notifyListeners(); // 重要：通知所有监听者
  }

  Future<void> _loadThemeFromStorage() async {
    try {
      final storedTheme = await Storage.getData('app_theme');
      if (storedTheme != null) {
        _themeMode = ThemeMode.values[storedTheme];
        notifyListeners();
      }
    } catch (e) {
      print('加载主题失败: $e');
    }
  }

  void _saveThemeToStorage() {
    Storage.setData('app_theme', _themeMode.index);
  }
}
