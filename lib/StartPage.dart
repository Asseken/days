import 'dart:async';

import 'package:days/pages/homepage.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _cuttime = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_cuttime == 0) {
        timer.cancel();
        _jumpToHomePage();
        return;
      }
      setState(() {
        _cuttime--;
      });
    });
  }

  void _jumpToHomePage() {
    //跳转事件
    // Navigator.of(context).pushReplacementNamed("/home");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const Homepage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: const Text('Startpage'),
      //   backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      // ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // child: const FlutterLogo(),
        child: const Image(image: AssetImage('assets/AppIcon/AppIcon.png')),
      ),
      // backgroundColor: const Color.fromARGB(255, 236, 232, 243),
    );
  }
}
