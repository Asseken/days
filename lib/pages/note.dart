import 'package:flutter/material.dart';

class everyday extends StatefulWidget {
  const everyday({super.key});

  @override
  State<everyday> createState() => _everydayState();
}

class _everydayState extends State<everyday> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("备忘录"),
        backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      ),
    );
  }
}
