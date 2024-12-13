import 'package:flutter/material.dart';
import '../model/local_data.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh', 'CN');

  Locale get locale => _locale;

  LanguageProvider() {
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    try {
      final languageCode = await StorageLa.getData('language_code') ?? 'zh';
      // print('Loaded language: $languageCode'); // Debug print
      if (_locale.languageCode != languageCode) {
        _locale = Locale(languageCode, '');
        notifyListeners();
      }
    } catch (e) {
      print("Error loading saved language: $e");
    }
  }

  void changeLanguage(String languageCode) async {
    // print('Changing language to: $languageCode');
    await StorageLa.setData('language_code', languageCode);

    _locale = Locale(languageCode, '');
    notifyListeners();
  }
}
