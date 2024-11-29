import 'package:flutter/material.dart';

class addnotepage extends StatefulWidget {
  const addnotepage({super.key});

  @override
  State<addnotepage> createState() => _addnotepageState();
}

class _addnotepageState extends State<addnotepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新建备忘录"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // 保存
            },
          ),],
        // backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      ),
      body: const Column(
        children: [
            TextField(
              decoration: InputDecoration(
                hintText: "请输入标题",
                border: OutlineInputBorder(),
              ),
            ),
          TextField(
            decoration: InputDecoration(
              hintText: "请输入内容",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
