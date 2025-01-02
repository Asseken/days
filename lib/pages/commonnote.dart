import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lunar_datetime_picker/date_init.dart';
import 'package:flutter_lunar_datetime_picker/flutter_lunar_datetime_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../l10n/l10n.dart';
import '../sql/sql_c.dart';
import '../widget/Dialog.dart';

class AddNotePage extends StatefulWidget {
  final int? id; // 可选的 ID 参数
  const AddNotePage({Key? key, this.id}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final sqlite dbHelper = sqlite();
  String title = "";
  String subtitle = "";
  String time = "";
  String tag = "生活";
  String content = "";
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    time = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    _controller = quill.QuillController.basic();

    // 判断是否传入了 id
    if (widget.id != null) {
      _loadNoteData(widget.id!);
    }
  }

  // final QuillController _controller = QuillController.basic();
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

  void _loadNoteData(int id) async {
    try {
      final noteData = await dbHelper.getOneData2(widget.id!);
      setState(() {
        title = noteData['title'] ?? '';
        subtitle = noteData['subtitle'] ?? '';
        time = noteData['time'] ?? time;
        tag = noteData['Tag'] ?? '生活';

        final description = noteData['description'];
        if (description != null) {
          final decodedContent = jsonDecode(description);
          _controller = quill.QuillController(
            document: quill.Document.fromJson(decodedContent),
            selection: const TextSelection.collapsed(offset: 0),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("加载失败：$e")),
      );
    }
  }

  void _saveNote() async {
    content = jsonEncode(_controller.document.toDelta().toJson());

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).PPci}!")),
      );
      return;
    }

    final noteData = {
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'Tag': tag,
      'description': content,
    };

    try {
      if (widget.id == null) {
        // 新建模式
        await dbHelper.insertData2(noteData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${S.of(context).SF}！")),
        );
      } else {
        // 编辑模式
        noteData['id'] = widget.id.toString();
        await dbHelper.updateData2(noteData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${S.of(context).UF}！")),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).FF}：$e")),
      );
      // print('保存失败：$e');
    }
  }

// 添加新标签的方法
  void _addNewTag(String newTag) {
    setState(() {
      // 将新标签设置为当前选中的标签
      tag = newTag;
    });
  }

  // 修改时间选择的方法
  void _selectDateTime() async {
    DateTime? pickedDateTime = await DatePicker.showDatePicker(
      context,
      lunarPicker: false,
      dateInitTime: DateInitTime(
        currentTime: DateTime.now(),
        maxTime: DateTime(2099, 12, 30),
        minTime: DateTime(1809, 1, 1),
      ),
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
        title: Text(
            widget.id == null ? S.of(context).NewMemo : S.of(context).EditMemo),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: title),
                decoration: InputDecoration(
                  labelText: S.of(context).NoteTitle,
                  border: const UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: subtitle),
                decoration: InputDecoration(
                  labelText: S.of(context).NoteSubTitle,
                  border: const UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  subtitle = value;
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.green, size: 40),
                    Text(S.of(context).Time,
                        style: const TextStyle(fontSize: 28)),
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
                  Row(
                    children: [
                      const Icon(Icons.tag, color: Colors.green, size: 40),
                      Text(
                        S.of(context).Label,
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
                    //small
                    IconButton(
                      icon: const Icon(Icons.text_fields),
                      onPressed: () => QrStyle(quill.Attribute.small),
                    ),
                    //blockQuote
                    IconButton(
                      icon: const Icon(Icons.format_quote),
                      onPressed: () => QrStyle(quill.Attribute.blockQuote),
                    ),
                  ],
                ),
              ),
              const Divider(),
              SingleChildScrollView(
                child: Expanded(
                  child: QuillEditor.basic(
                    controller: _controller,
                    configurations: const QuillEditorConfigurations(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          _saveNote();
        },
        // backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
