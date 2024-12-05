import 'package:days/sql/sql_c.dart';
import 'package:days/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Startpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = sqlite();
  await db.initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Days',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const Startpage(),
        );
      },
    );
    // return MaterialApp(
    //   title: 'Days',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //         seedColor: const Color.fromARGB(255, 208, 188, 242)),
    //     useMaterial3: true,
    //   ),
    //   home: const Startpage(),
    // );
  }
}
