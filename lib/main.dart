import 'package:days/sql/sql_c.dart';
import 'package:days/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'StartPage.dart';
import '../l10n/l10n.dart';
import 'model/LanguageProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = sqlite();
  await db.initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Days',
          theme: themeProvider.getCurrentTheme(),
          themeMode: themeProvider.themeMode,
          locale: languageProvider.locale, // 绑定 locale
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
          ],
          home: const StartPage(),
        );
      },
    );
  }
}
