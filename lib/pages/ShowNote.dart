import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../sql/sql_c.dart';
import 'commonnote.dart';

class ShowNotePage extends StatefulWidget {
  final int id;
  final VoidCallback Onref; // 回调函数
  const ShowNotePage({super.key, required this.id, required this.Onref});

  @override
  State<ShowNotePage> createState() => _ShowNotePageState();
}

class _ShowNotePageState extends State<ShowNotePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Loaddata();
  }

  final sqlite dbHelper = sqlite();
  // final List<Map<String, dynamic>> _dataList = [];
  Map<String, dynamic>? _NoteataList; // 存储当前获取的数据
  QuillController? _controller;
  bool _isLoading = true; // 添加加载状态
  // 传入的id
  // 加载数据
  Future<void> Loaddata() async {
    final data = await dbHelper.getOneData2(widget.id); // 获取单条数据
    setState(() {
      _NoteataList = data; // 保存到 _currentData 中
      _controller = QuillController.basic();

      // 如果 description 是以 JSON 格式存储的富文本内容
      if (_NoteataList?['description'] != null) {
        try {
          final richTextContent = jsonDecode(_NoteataList?['description']);
          _controller = QuillController(
            document: Document.fromJson(richTextContent),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("出bug啦$e")),
          );
        }
      }
      _isLoading = false; // 加载完成
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_NoteataList?['title'] ?? ''),
        actions: [
          IconButton(
            onPressed: () async {
              // 跳转到编辑页面
              final re = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNotePage(id: widget.id)));
              if (re != null) {
                // 如果有更新数据，触发主页的更新函数
                if (re) {
                  // 调用主页的更新数据函数
                  setState(() {
                    widget.Onref();
                    Loaddata();
                  });
                }
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                _NoteataList?['title'] ?? '',
                style: const TextStyle(fontSize: 40),
              ),
            ),
            Text(
              _NoteataList?['subtitle'] ?? '',
              style: const TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_NoteataList?['time'] ?? ''),
                const SizedBox(
                  width: 10,
                ),
                Text(_NoteataList?['Tag'] ?? ''),
              ],
            ),
            const Divider(),
            Expanded(
              child: _controller != null
                  ? QuillEditor.basic(
                      controller: _controller,
                      configurations: const QuillEditorConfigurations(),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
