import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lunar_datetime_picker/date_init.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../Flutter_Quill/quill.dart';
import '../sql/sql_c.dart';
import '../widget/Dialog.dart';
import '../widget/FlButton.dart';
import 'package:intl/intl.dart';
import 'package:flutter_lunar_datetime_picker/flutter_lunar_datetime_picker.dart';

class addnotepage extends StatefulWidget {
  final int? id;
  const addnotepage({super.key, this.id});

  @override
  State<addnotepage> createState() => _addnotepageState();
}

class _addnotepageState extends State<addnotepage> {
  final sqlite dbHelper = sqlite();
  String titel = "";
  String subtitel = "";
  String time = "";
  String tag = "生活";
  String content = "";
  // late QuillEditorComponent _quillEditor;
  void _SaveNote() async {
    // 获取富文本编辑器的内容
    content = jsonEncode(_controller.document.toDelta().toJson());
    // 保存
    if (titel.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请填写完整信息！")),
      );
      return;
    }
// 准备数据
    Map<String, dynamic> noteData = {
      'title': titel,
      'subtitle': subtitel,
      'time': time,
      'Tag': tag,
      'description': content,
      'value': 0 // 可以根据需要设置值
    };

    try {
      // 插入数据到数据库
      await dbHelper.insertData2(noteData);

      // 提示保存成功
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("备忘录保存成功！")),
      );
      Navigator.pop(context, true);
      // 可以选择返回上一页
      // Navigator.pop(context);
    } catch (e) {
      // 处理可能的错误
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("保存失败：$e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // 设置当前时间
    time = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    // Initialize QuillEditorComponent
    // _quillEditor = QuillEditorComponent(
    //   onStyleApplied: (quill.Attribute attribute) {
    //     // Optional: Add any additional logic when a style is applied
    //   },
    // );
  }

// 添加新标签的方法
  void _addNewTag(String newTag) {
    setState(() {
      // 将新标签设置为当前选中的标签
      tag = newTag;
    });
  }

  final QuillController _controller = QuillController.basic();
  void QrStyle(quill.Attribute attribute) {
    final currentSelection = _controller.getSelectionStyle();
    if (currentSelection.attributes.containsKey(attribute.key)) {
      // 如果已经应用了该格式，则取消
      _controller.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      // 否则添加格式
      _controller.formatSelection(attribute);
    }
  }

  // 修改时间选择的方法
  void _selectDateTime() async {
    DateTime? pickedDateTime = await DatePicker.showDatePicker(
      context,
      lunarPicker: false,
      dateInitTime: DateInitTime(
          currentTime: DateTime.now(),
          maxTime: DateTime(2026, 12, 12),
          minTime: DateTime(2018, 3, 4)),
    );

    if (pickedDateTime != null) {
      setState(() {
        // 如果用户选择了时间，使用选择的时间
        time = DateFormat('yyyy-MM-dd HH:mm').format(pickedDateTime);
      });
    } else {
      // 如果用户取消选择，保持当前系统时间
      setState(() {
        time = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新建备忘录"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _SaveNote(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "请输入标题",
                  labelText: "标题",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  titel = value;
                },
              ),
              const SizedBox(height: 8), // 间隔(10像素
              TextField(
                decoration: const InputDecoration(
                  hintText: "请输入副内容",
                  labelText: "副标题",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                onChanged: (value) {
                  subtitel = value;
                },
              ),
              const SizedBox(height: 4), // 间隔(10像素
              // Divider(),
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.green, size: 40),
                    const Text("时间:", style: TextStyle(fontSize: 28)),
                    GestureDetector(
                      onTap: _selectDateTime,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          time,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tag, color: Colors.green, size: 40),
                      Text(
                        "标签",
                        style: TextStyle(fontSize: 28),
                      ),
                    ],
                  ),
                  Text(
                    tag.length > 6 ? "${tag.substring(0, 6)}..." : tag,
                    style: const TextStyle(fontSize: 28),
                  ),
                  IconButton(
                    onPressed: () {
                      AddNoteTag.showAddNoteTagDialog(context, _addNewTag);
                    },
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.blue, size: 40),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 设置为水平滚动
                child: Row(
                  children: [
                    //撤回
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: () {
                        _controller.undo();
                      },
                    ),
                    //重做
                    IconButton(
                      icon: const Icon(Icons.redo),
                      onPressed: () {
                        _controller.redo();
                      },
                    ),
                    //加粗
                    IconButton(
                      icon: const Icon(Icons.format_bold),
                      onPressed: () => QrStyle(quill.Attribute.bold),
                    ),
                    //斜体
                    IconButton(
                      icon: const Icon(Icons.format_italic),
                      onPressed: () => QrStyle(quill.Attribute.italic),
                    ),
                    //下划线
                    IconButton(
                      icon: const Icon(Icons.format_underlined),
                      onPressed: () => QrStyle(quill.Attribute.underline),
                    ),
                    //删除线
                    IconButton(
                      icon: const Icon(Icons.format_strikethrough),
                      onPressed: () => QrStyle(quill.Attribute.strikeThrough),
                    ),
                    //代码
                    IconButton(
                      icon: const Icon(Icons.code),
                      onPressed: () => QrStyle(quill.Attribute.codeBlock),
                    ),
                    //subscript
                    IconButton(
                      icon: const Icon(Icons.subscript),
                      onPressed: () => QrStyle(quill.Attribute.subscript),
                    ),
                    //superscript
                    IconButton(
                      icon: const Icon(Icons.superscript),
                      onPressed: () => QrStyle(quill.Attribute.superscript),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: QuillEditor.basic(
                  controller: _controller,
                  configurations: const QuillEditorConfigurations(),
                ),
              ),
            ],
          ),
        ),
      ),
      //获取输入的内容
      floatingActionButton: SaveNote(context, _SaveNote),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
