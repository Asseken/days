import 'package:days/pages/add.dart';
import 'package:days/pages/setting.dart';
import 'package:days/pages/showcunday.dart';
import 'package:days/sql/sql_c.dart';
import 'package:days/widget/flbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/datejs.dart';
import '../widget/deledialog.dart';
import 'common.dart';

class firstpage extends StatefulWidget {
  const firstpage({super.key});

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  final sqlite dbHelper = sqlite();
  List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await dbHelper.getAllData();
    setState(() {
      // _dataList = data;
      _dataList = data.reversed.toList(); // 将数据反转，最新的数据会排在最前面
    });
  }

// 修改后的编辑按钮点击事件
  void _onEdit() async {
    await _loadData(); // 刷新数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("倒数日"),
        backgroundColor: const Color.fromARGB(255, 181, 234, 202),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final re = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddEditcommon()));
              if (re != null) {
                _loadData();
              }
            },
          ),
        ],
      ),
      drawer: const Drawer(
        child: Setting(),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (context, index) {
            final item = _dataList[index];
            return Dismissible(
              key: Key(item['id'].toString()), // 使用唯一的 Key 来标识每个项
              direction: DismissDirection.horizontal, // 向右滑动
              background: Container(
                color: Colors.red, // 删除时显示的背景色
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              secondaryBackground: Container(
                color: Colors.blue, // 编辑时显示的背景色
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  // 左滑删除
                  DeleteDialog.showDeleteDialog(
                    context,
                    item['id'],
                    dbHelper,
                    _loadData,
                    // 刷新数据的回调
                  );

                  return false; // 触发删除
                } else if (direction == DismissDirection.endToStart) {
                  // 右滑编辑
                  edit.showEditDialog(
                    context,
                    item['id'],
                    dbHelper,
                    // _loadData, // 刷新数据的回调
                    _onEdit, // 编辑后的回调
                  );
                  return false; // 不触发删除
                }
                return false;
              },
              child: GestureDetector(
                child: Card(
                  color: const Color.fromARGB(255, 181, 234, 202),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.fromLTRB(10, 8, 10, 5),
                  child: Column(
                    children: [
                      ListTile(
                        title: Center(
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  item['name'].length > 5
                                      ? "${item['name'].substring(0, 5)}..."
                                      : item['name'],
                                  style: TextStyle(
                                    fontSize: item['name'].length > 5 ? 30 : 35,
                                  ), // 如果文本长度大于5，字体变小),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 1, 16, 0),
                                child: Text(
                                  compareDates(
                                    item['time'],
                                  ),
                                  style: const TextStyle(fontSize: 32),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "时间: ${item['time']}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "标记: ${item['Typedes']}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // 点击事件
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => shouwcuntday(
                        id: item['id'],
                        onEdit: () {
                          _loadData();
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: flbutton(context, _loadData),
    );
  }
}
