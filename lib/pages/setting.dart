import 'package:days/model/update.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: const Color.fromARGB(255, 181, 234, 202),
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
          ListTile(
            title: const Text("暗黑模式"),
            trailing: Switch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          const Divider(),
          ListTile(
              title: const Text("切换语言"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {

              }),
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
              const url = 'https://github.com/Asseken/days-test';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw "Could not launch $url";
              }
                  },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
