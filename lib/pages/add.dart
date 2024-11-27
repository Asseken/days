import 'package:days/sql/sql_c.dart';
import 'package:flutter/material.dart';

import '../widget/dropdownmenu.dart';

class addpage extends StatefulWidget {
  const addpage({super.key});

  @override
  State<addpage> createState() => _addpageState();
}

class _addpageState extends State<addpage> {
  final sqlite dbHelper = sqlite();
  String BT = "";
  // String time = "";
  String des = "";
  String typedesdropdownmenu = "不知道";
  bool isLunar = false; // 是否为阴历
  DateTime currentDate = DateTime.now(); // 当前时间

  void _saveData() async {
    if (BT.isEmpty || formattedDate.isEmpty || des.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请填写完整信息！")),
      );
      return;
    }

    Map<String, dynamic> data = {
      'name': BT,
      'time': formattedDate,
      'description': des,
      'Typedes': typedesdropdownmenu,
      'value': 0
    };

    await dbHelper.insertData(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("保存成功啦")),
    );

    Navigator.pop(context, true);
    // print("object");
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
        title: const Text("添加倒数日"),
        backgroundColor: const Color.fromARGB(255, 181, 234, 202),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveData();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                BT = value;
              },
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
            const Divider(),
            const SizedBox(height: 10),

            DropdownMenuNode1(
              onValueChanged: (value) {
                typedesdropdownmenu = value;
              },
            ),

            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                des = value;
              },
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '描述',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              // child: Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _saveData();
                  // print(formattedDate.runtimeType);
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
