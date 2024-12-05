import 'package:days/model/update.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
        // backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.all(10),
                width: 200,
                height: 200,
                child: const FlutterLogo(size: 100)),
          ),
          const Divider(),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                title:
                    Text("主题模式 ${_getThemeModeText(themeProvider.themeMode)}"),
                // subtitle: Text(_getThemeModeText(themeProvider.themeMode)),
                trailing: IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
              title: const Text("切换语言"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {}),
          const Divider(),
          ListTile(
            title: const Text("检查更新"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Getpackgeinfo.githubrelease(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("项目源码"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              //打开浏览器
              const url = 'https://github.com/Asseken/days';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw "Could not launch $url";
              }
            },
          ),
          const Divider(),
          const Center(
            child: Text(
              "ZJL & ZDM 2024",
              style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  /// 根据主题模式返回对应的文字描述
  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '亮色模式';
      case ThemeMode.dark:
        return '暗色模式';
    }
  }
}
// Consumer<ThemeProvider>(
// builder: (context, themeProvider, child) {
// return ListTile(
// title: const Text("暗黑模式"),
// trailing: Switch(
// value: themeProvider.themeMode == ThemeMode.dark,
// onChanged: (bool value) {
// themeProvider.toggleTheme();
// },
// ),
// );
// },
