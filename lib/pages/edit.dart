import 'package:flutter/material.dart';

import '../sql/sql_c.dart';
import '../widget/dropdownmenu.dart';

class editcunday extends StatefulWidget {
  final int id;
  const editcunday({super.key, required this.id});

  @override
  State<editcunday> createState() => _editcundayState();
}

class _editcundayState extends State<editcunday> {
  final sqlite dbHelper = sqlite();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String typedesdropdownmenu = "不知道";
  bool isLunar = false; // 是否为阴历
  String formattedDate = ""; // 格式化后的日期

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _loadData(); // 加载数据
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  /// 从数据库中加载数据
  Future<void> _loadData() async {
    final data = await dbHelper.getOneData(widget.id);
    if (data.isNotEmpty) {
      setState(() {
        _titleController.text = data['name'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        // isLunar = data['isLunar'] == 1; // 数据库存储布尔值时可以用整数表示
        formattedDate = data['time'] ?? '';
        typedesdropdownmenu = data['Typedes'] ?? '';
      });
    }
  }

  /// 保存数据
  Future<void> _saveData() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请填写完整信息！")),
      );
      return;
    }

    final updatedData = {
      'id': widget.id,
      'name': _titleController.text,
      'time': formattedDate,
      'description': _descriptionController.text,
      'Typedes': typedesdropdownmenu,
    };

    await dbHelper.updateData(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("更新成功啦！")),
    );

    Navigator.pop(context, updatedData); // 返回更新后的数据
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
      initialDate: DateTime.now(),
      firstDate: DateTime(1099),
      lastDate: DateTime(2099),
      helpText: isLunar ? '选择阴历日期' : '选择公历日期',
    );

    if (selectedDate != null) {
      setState(() {
        formattedDate = isLunar
            ? _convertToLunar(selectedDate)
            : "${selectedDate.toIso8601String().split('T')[0]} ${_getWeekday(selectedDate.weekday)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '输入事件标题',
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
                    style: const TextStyle(fontSize: 18, color: Colors.blue),
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
            DropdownMenuNode1(
              onValueChanged: (value) {
                setState(() {
                  typedesdropdownmenu = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '描述',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              // child: Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveData();
                  // print("6666666");
                },
                child: const Text("保存"),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
