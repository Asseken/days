import 'package:flutter/material.dart';
import 'package:days/sql/sql_c.dart';
import 'package:days/widget/dropdownmenu.dart';

import '../l10n/l10n.dart';

class AddEditcommon extends StatefulWidget {
  final int? id; // Optional ID for editing an existing entry

  const AddEditcommon({super.key, this.id});

  @override
  State<AddEditcommon> createState() => _AddEditcommonState();
}

class _AddEditcommonState extends State<AddEditcommon> {
  final sqlite dbHelper = sqlite();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String typedesdropdownmenu = "不知道";
  bool isLunar = false;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.id != null) {
      _loadData(); // Load existing data for editing
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// 加载现有数据
  Future<void> _loadData() async {
    final data = await dbHelper.getOneData(widget.id!);
    if (data.isNotEmpty) {
      setState(() {
        _titleController.text = data['name'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        typedesdropdownmenu = data['Typedes'] ?? '不知道';
        currentDate = DateTime.parse(data['time'].split(' ')[0]);
      });
    }
  }

  /// 保存数据
  Future<void> _saveData() async {
    if (_titleController.text.isEmpty ||
        formattedDate.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).PPci}！")),
      );
      return;
    }

    final data = {
      'name': _titleController.text,
      'time': formattedDate,
      'description': _descriptionController.text,
      'Typedes': typedesdropdownmenu,
      'value': 0
    };
    try {
      if (widget.id == null) {
        // 新增逻辑
        await dbHelper.insertData(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).SF)),
        );
      } else {
        // 编辑逻辑
        data['id'] = widget.id as Object;
        await dbHelper.updateData(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).UF)),
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

  /// 获取格式化的日期
  String get formattedDate {
    return isLunar
        ? _convertToLunar(currentDate)
        : "${currentDate.toIso8601String().split('T')[0]} ${_getWeekday(currentDate.weekday)}";
  }

  /// 转换日期为阴历（自定义逻辑）
  String _convertToLunar(DateTime date) {
    // 此处添加阴历转换逻辑（可通过依赖库实现，如 chinese_lunar）
    return "阴历日期";
  }

  /// 获取星期几
  String _getWeekday(int weekday) {
    const weekdays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
    return weekdays[weekday - 1];
  }

  /// 弹出日期选择器
  Future<void> _pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1099),
      lastDate: DateTime(2099),
      helpText: isLunar ? '选择阴历日期' : '选择公历日期',
    );

    if (selectedDate != null) {
      setState(() {
        currentDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.id == null
              ? S.of(context).AddCountdownDay
              : S.of(context).EditCountdownDay),
          // backgroundColor: const Color.fromARGB(255, 181, 234, 202),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveData,
            ),
          ],
        ),
        body: SafeArea(
            child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).NoteTitle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _pickDate,
                        child: Text(
                          formattedDate,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      ),
                      ToggleButtons(
                        isSelected: [!isLunar, isLunar],
                        onPressed: (index) {
                          setState(() {
                            isLunar = index == 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(5),
                        selectedBorderColor: Colors.blue,
                        selectedColor: Colors.white,
                        fillColor: Colors.blue,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("公历"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("阴历"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  DropdownMenuNode1(
                    onValueChanged: (value) {
                      typedesdropdownmenu = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).NoteContent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size.fromHeight(50), // Make button full width
                      ),
                      child: Text(S.of(context).Save),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
