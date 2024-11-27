import 'package:flutter/material.dart';

class DropdownMenuNode1 extends StatefulWidget {
  final ValueChanged<String> onValueChanged; // 添加回调函数

  const DropdownMenuNode1({super.key, required this.onValueChanged});

  @override
  State<DropdownMenuNode1> createState() => _DropdownMenuNode1State();
}

class _DropdownMenuNode1State extends State<DropdownMenuNode1> {
  final List<String> data = ['不知道', '生活', '纪念日', '工作'];
  late String _dropdownValue = data[0];
  final List _colorchos = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.book_outlined,
          color: _colorchos[data.indexOf(_dropdownValue)],
          size: 40,
        ),
        const SizedBox(width: 15),
        Text('类型: $_dropdownValue', style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 15),
        Container(
          alignment: Alignment.centerRight,
          child: DropdownButton<String>(
            value: _dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.blue, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.blue,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue!;
                widget.onValueChanged(_dropdownValue); // 通过回调函数传递值
              });
            },
            items: data.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: _colorchos[data.indexOf(value)],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
