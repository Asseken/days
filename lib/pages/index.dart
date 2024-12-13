import 'package:days/pages/setting.dart';
import 'package:days/pages/showcunday.dart';
import 'package:days/sql/sql_c.dart';
import 'package:days/widget/FlButton.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../model/datejs.dart';
import '../widget/Dialog.dart';
import 'common.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
        title: Text(S.of(context).CountdownDay),
        // backgroundColor: const Color.fromARGB(255, 181, 234, 202),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final re = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddEditcommon()));
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
      body: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          final item = _dataList[index];
          return GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              margin: const EdgeInsets.fromLTRB(5, 8, 5, 5),
              child: Column(
                children: [
                  ListTile(
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            item['name'].length > 5
                                ? "${item['name'].substring(0, 5)}..."
                                : item['name'],
                            style: const TextStyle(
                              fontSize: 35,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(3, 0, 5, 0),
                            child: Text(
                              compareDates(
                                item['time'],
                              ),
                              style: const TextStyle(fontSize: 35),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${S.of(context).Time}${item['time']}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${S.of(context).Type}${item['Typedes']}",
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
            onLongPress: () {
              // 长按事件
              DeleteEditAll.showDeleteEditAllDialog(
                  context, item['id'], dbHelper, _onEdit, _loadData);
            },
          );
        },
      ),
      floatingActionButton: flbutton(context, _loadData),
    );
  }
}
