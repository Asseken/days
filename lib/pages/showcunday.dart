import 'package:days/pages/common.dart';
import 'package:flutter/material.dart';

import '../model/datejs.dart';
import '../sql/sql_c.dart';

class shouwcuntday extends StatefulWidget {
  final int id;

  final VoidCallback onEdit; // 回调函数
  const shouwcuntday({super.key, required this.id, required this.onEdit});

  @override
  State<shouwcuntday> createState() => _shouwcuntdayState();
}

class _shouwcuntdayState extends State<shouwcuntday> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddata();
  }

  final sqlite dbHelper = sqlite();
  // final List<Map<String, dynamic>> _dataList = [];
  Map<String, dynamic>? _dataList; // 存储当前获取的数据
  // 传入的id
  // 加载数据
  Future<void> loaddata() async {
    final data = await dbHelper.getOneData(widget.id); // 获取单条数据
    setState(() {
      _dataList = data; // 保存到 _currentData 中
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dataList?['name'] ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // 保存
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditcommon(id: widget.id,),
                ),
              );
              // 如果有更新数据，触发主页的更新函数
              if (updatedData != null) {
                // 调用主页的更新数据函数
                setState(() {
                  widget.onEdit();
                  loaddata();
                });
              }
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            // color: const Color.fromARGB(255, 179, 237, 201),
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 179, 237, 201),
            ),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // 设置为水平方向滚动
                    child: SizedBox(
                      // width: double.infinity,
                      child: Text(
                        _dataList?['name']??'',
                        style: const TextStyle(
                            fontSize: 37, fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Text(_dataList?['time'] != null
                          ?
                      "距离${_dataList?['name']}${compareDates(_dataList?['time'])}":"",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(233, 84, 151, 243),
                        ),
                        maxLines: 2,
                      ),
                    )),
                const SizedBox(height: 10),
                SizedBox(
                  child: Text("描述:${_dataList?['description']}",
                      style: const TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2),
                ),
                Text("时间:${_dataList?['time']}",
                    style: const TextStyle(fontSize: 20)),
                const Divider(),
                Text("标记:${_dataList?['Typedes']}",
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
