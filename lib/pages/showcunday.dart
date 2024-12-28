import 'package:days/pages/common.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../model/datejs.dart';
import '../sql/sql_c.dart';

class ShowCuntDay extends StatefulWidget {
  final int id;

  final VoidCallback onEdit; // 回调函数
  const ShowCuntDay({super.key, required this.id, required this.onEdit});

  @override
  State<ShowCuntDay> createState() => _ShowCuntDayState();
}

class _ShowCuntDayState extends State<ShowCuntDay> {
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
                  builder: (context) => AddEditcommon(
                    id: widget.id,
                  ),
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
        // backgroundColor: const Color.fromARGB(255, 181, 234, 202),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 计算最佳宽度和边距
                  double maxWidth = constraints.maxWidth;
                  double containerWidth = orientation == Orientation.portrait
                      ? maxWidth * 0.9 // 竖屏时占据90%宽度
                      : maxWidth * 0.7; // 横屏时占据70%宽度

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        width: containerWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: const Color.fromARGB(255, 179, 237, 201),
                        ),
                        child: _buildDetailContent(_dataList, context),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 分享
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}

Widget _buildDetailContent(_dataList, BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
// color: const Color.fromARGB(255, 179, 237, 201),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
          // color: const Color.fromARGB(255, 221, 179, 255),
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
                    _dataList?['name'] ?? '',
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
                child: Text(
                  _dataList?['time'] != null
                      ? "距离${_dataList?['name']}${compareDates(_dataList?['time'])}"
                      : "",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(233, 84, 151, 243),
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Text(
                  "${S.of(context).NoteContent}:${_dataList?['description']}",
                  style: const TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 2),
            ),
            Text("${S.of(context).Time}${_dataList?['time']}",
                style: const TextStyle(fontSize: 20)),
            const Divider(),
            Text("${S.of(context).Type}${_dataList?['Typedes']}",
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    ),
  );
}
