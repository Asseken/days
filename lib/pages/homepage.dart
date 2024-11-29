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
  final List<Widget> _listpage = [
    const firstpage(),
    const addnotepage(),
    const everyday(),
    const Setting(),
  ];
  void _topp(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listpage[_selectedindex],

      bottomNavigationBar: BottomNavigationBar(
        // unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "添加",
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
