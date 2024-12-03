import 'package:days/pages/ShowNote.dart';
import 'package:days/widget/Dialog.dart';
import 'package:days/widget/FlButton.dart';
import 'package:flutter/material.dart';

import '../sql/sql_c.dart';

class AllNoteDisplay extends StatefulWidget {
  const AllNoteDisplay({super.key});

  @override
  State<AllNoteDisplay> createState() => _AllNoteDisplayState();
}

class _AllNoteDisplayState extends State<AllNoteDisplay> {
  final sqlite dbHelper = sqlite();
  List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await dbHelper.getAllData2();
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
        title: const Text("备忘录"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 根据约束宽度动态计算列数
          int crossAxisCount;
          if (constraints.maxWidth > 1800) {
            crossAxisCount = 6;
          } else if (constraints.maxWidth > 1200) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 3;
          } else if (constraints.maxWidth > 400) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 2;
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // 每行显示2个
              crossAxisSpacing: 10, // 网格之间的水平间距
              mainAxisSpacing: 10, // 网格之间的垂直间距
              childAspectRatio: 0.8, // 控制每个网格项的宽高比
            ),
            itemCount: _dataList.length,
            itemBuilder: (context, index) {
              final item = _dataList[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowNotePage(
                            id: item['id'],
                            Onref: () {
                              _onEdit();
                            },
                          )),
                ),
                onLongPress: () => DeleteNote.showDeleteNoteDialog(
                  context,
                  item['id'],
                  dbHelper,
                  _loadData,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: // 标题
                                Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 副标题（如果不为空）
                        if (item['subtitle'] != null &&
                            item['subtitle'].isNotEmpty)
                          Text(
                            item['subtitle'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),

                        const Spacer(), // 推动底部信息到底部

                        // 时间和标签
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['time'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            // if (item['Tag'] != null && item['Tag'].isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item['Tag'].length > 3
                                    ? "${item['Tag'].substring(0, 3)}.."
                                    : item['Tag'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: AddNote(context, _loadData),
    );
  }
}
