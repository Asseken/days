import 'dart:io';

import 'package:days/pages/addnote.dart';
import 'package:days/pages/index.dart';
import 'package:days/pages/setting.dart';
import 'package:flutter/material.dart';

import 'note.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedindex = 0;
  late PageController _PageViewController; // PageView 的控制器
  final List<Widget> _listpage = [
    const FirstPage(),
    const AllNoteDisplay(),
    const Setting(),
  ];
  void _topp(int index) {
    setState(() {
      _selectedindex = index;
      _PageViewController.jumpToPage(index);
      // _PageViewController.animateToPage(
      //   index,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeInOut,
      // );
    });
  }

  @override
  void initState() {
    super.initState();
    _PageViewController = PageController(); // 初始化控制器
  }

  @override
  void dispose() {
    _PageViewController.dispose(); // 销毁控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否是 Windows 平台
    final bool isWindows = Platform.isWindows;
    return Scaffold(
      // body: PageView(
      //   controller: _PageViewController,
      //   children: _listpage,
      //   onPageChanged: (index) {
      //     setState(() {
      //       _selectedindex = index;
      //     });
      //   },
      // ),
      body: isWindows
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedindex,
                  onDestinationSelected: (index) => _topp(index),
                  labelType: NavigationRailLabelType.all, // 强制显示所有标签
                  // extended: true, // 扩展 NavigationRail 以显示完整标签
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("首页"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.date_range_sharp),
                      label: Text('事项'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('设置'),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: _PageViewController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedindex = index;
                      });
                    },
                    children: _listpage,
                  ),
                ),
              ],
            )
          : PageView(
              controller: _PageViewController,
              onPageChanged: (index) {
                setState(() {
                  _selectedindex = index;
                });
              },
              children: _listpage,
            ),

      bottomNavigationBar: isWindows
          ? null // Windows 平台不显示 BottomNavigationBar
          : BottomNavigationBar(
              // unselectedItemColor: Colors.grey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "首页",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.date_range_sharp), label: "事项"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: "设置",
                ),
              ],
              currentIndex: _selectedindex,
              // selectedItemColor: Colors.green,
              onTap: _topp,
            ),
    );
  }
}
