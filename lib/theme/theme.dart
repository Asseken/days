import 'package:flutter/material.dart';

import '../model/local_data.dart';

class AppTheme {
  /// 亮色主题配置
  static ThemeData lightTheme = ThemeData(
    // 主要颜色配置
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 245, 237, 246),
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
      color: Color.fromARGB(255, 221, 179, 255),
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
    //card theme
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 221, 179, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    //底部状态栏
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 253, 252, 255),
      selectedItemColor: Color.fromARGB(255, 221, 179, 255),
      unselectedItemColor: Color.fromARGB(255, 193, 192, 192),
    ),
    //FloatingActionButton配置
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 221, 179, 255),
      foregroundColor: Colors.white,
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
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
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
    //card theme
    cardTheme: CardTheme(
      color: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    //底部状态栏
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 221, 179, 255),
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.white,
    ),
  );
}

/// 主题切换提供者
class ThemeProvider extends ChangeNotifier {
  // ThemeMode _themeMode = ThemeMode.light;
// 当前主题模式，默认为跟随系统
  ThemeMode _themeMode = ThemeMode.system;
  ThemeProvider() {
    _loadThemeFromStorage();
  }

  ThemeMode get themeMode => _themeMode;

  // bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// 切换主题
  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
    }

    _saveThemeToStorage();
    notifyListeners(); // 重要：通知所有监听者
  }

  /// 设置特定的主题模式
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;

    // 保存主题状态到本地存储
    _saveThemeToStorage();

    notifyListeners();
  }

  Future<void> _loadThemeFromStorage() async {
    try {
      final storedTheme = await Storage.getData('app_theme');
      if (storedTheme != null) {
        _themeMode = ThemeMode.values[storedTheme];
        notifyListeners();
      }
    } catch (e) {
      // 如果没有存储的主题，保持默认系统主题
      _themeMode = ThemeMode.system;
      print('加载主题失败: $e');
    }
  }

  void _saveThemeToStorage() {
    Storage.setData('app_theme', _themeMode.index);
  }
}
