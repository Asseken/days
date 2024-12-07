import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../model/local_data.dart';

class AppTheme {
  /// 预定义的主题配色方案
  static final List<FlexScheme> availableSchemes = [
    FlexScheme.material,
    FlexScheme.blue,
    FlexScheme.indigo,
    FlexScheme.aquaBlue,
    FlexScheme.materialHc,
    FlexScheme.sakura,
    FlexScheme.money,
    FlexScheme.deepBlue,
    FlexScheme.brandBlue,
    FlexScheme.red,
    FlexScheme.redWine,
    FlexScheme.purpleBrown,

  ];

  /// 生成亮色主题
  static ThemeData getLightTheme(FlexScheme scheme) {
    return FlexThemeData.light(
      scheme: scheme,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        blendTextTheme: true,
        useTextTheme: true,
        inputDecoratorRadius: 8.0,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        elevatedButtonRadius: 8.0,
        cardRadius: 10.0,
      ),
    );
  }

  /// 生成暗色主题
  static ThemeData getDarkTheme(FlexScheme scheme) {
    return FlexThemeData.dark(
      scheme: scheme,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      subThemesData: const FlexSubThemesData(
        blendTextTheme: true,
        useTextTheme: true,
        inputDecoratorRadius: 8.0,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        elevatedButtonRadius: 8.0,
        cardRadius: 10.0,
      ),
    );
  }
}

/// 主题切换提供者
class ThemeProvider extends ChangeNotifier {
  // 当前主题模式，默认为跟随系统
  ThemeMode _themeMode = ThemeMode.system;

  // 当前选中的主题配色方案，默认为第一个
  FlexScheme _currentScheme = AppTheme.availableSchemes.first;

  ThemeProvider() {
    _loadThemeFromStorage();
  }

  ThemeMode get themeMode => _themeMode;
  FlexScheme get currentScheme => _currentScheme;

  /// 切换主题模式
  void toggleThemeMode() {
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
    notifyListeners();
  }

  /// 切换主题配色方案
  void changeColorScheme(FlexScheme scheme) {
    _currentScheme = scheme;
    _saveThemeToStorage();
    notifyListeners();
  }

  /// 设置特定的主题模式
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeToStorage();
    notifyListeners();
  }

  Future<void> _loadThemeFromStorage() async {
    try {
      final storedTheme = await Storage.getData('app_theme');
      final storedScheme = await Storage.getData('app_color_scheme');

      if (storedTheme != null) {
        _themeMode = ThemeMode.values[storedTheme];
      }

      if (storedScheme != null) {
        _currentScheme = AppTheme.availableSchemes[storedScheme];
      }

      notifyListeners();
    } catch (e) {
      _themeMode = ThemeMode.system;
      _currentScheme = AppTheme.availableSchemes.first;
    }
  }

  void _saveThemeToStorage() {
    Storage.setData('app_theme', _themeMode.index);
    Storage.setData('app_color_scheme', AppTheme.availableSchemes.indexOf(_currentScheme));
  }

  /// 获取当前主题
  ThemeData getCurrentTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.getLightTheme(_currentScheme);
      case ThemeMode.dark:
        return AppTheme.getDarkTheme(_currentScheme);
      case ThemeMode.system:
        return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
            ? AppTheme.getDarkTheme(_currentScheme)
            : AppTheme.getLightTheme(_currentScheme);
    }
  }
}