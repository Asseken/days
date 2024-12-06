import 'package:days/pages/ShowNote.dart';
import 'package:days/widget/Dialog.dart';
import 'package:days/widget/FlButton.dart';
import 'package:flutter/material.dart';

import '../model/local_data.dart';
import '../sql/sql_c.dart';
import 'commonnote.dart';

class AllNoteDisplay extends StatefulWidget {
  const AllNoteDisplay({super.key});

  @override
  State<AllNoteDisplay> createState() => _AllNoteDisplayState();
}

class _AllNoteDisplayState extends State<AllNoteDisplay> {
  final sqlite dbHelper = sqlite();
  List<Map<String, dynamic>> _dataList = [];
  bool _isCompactMode = false;
  bool _isAscendingOrder = false; // 新增排序状态

  @override
  void initState() {
    super.initState();
    // _loadData();
    // _loadUserPreferences(); // 加载用户偏好设置
    // 先加载用户偏好设置，然后再加载数据
    _loadUserPreferences().then((_) {
      _loadData();
    });
  }

//  加载用户偏好设置
  Future<void> _loadUserPreferences() async {
    try {
      // 读取紧凑模式设置
      _isCompactMode = await StorageForBool.getData('compactMode') ?? false;

      // 读取排序方式设置
      _isAscendingOrder = await StorageForBool.getData('sortOrder') ?? false;
    } catch (e) {
      // 如果读取失败，使用默认值
      _isCompactMode = false;
      _isAscendingOrder = false;
    }
    setState(() {}); // 触发界面重绘
  }

  Future<void> _loadData() async {
    final data = await dbHelper.getAllData2();
    setState(() {
      // _dataList = data;
      // _dataList = data.reversed.toList(); // 将数据反转，最新的数据会排在最前面
      // 根据排序状态决定数据排序
      _dataList = _isAscendingOrder ? data : data.reversed.toList();
    });
  }

  // 切换紧凑/宽松模式
  void _toggleCompactMode() {
    setState(() {
      _isCompactMode = !_isCompactMode;
    });
    // 保存用户设置
    StorageForBool.setData('compactMode', _isCompactMode);
  }

  // 切换排序方式
  void _toggleSortOrder() {
    setState(() {
      _isAscendingOrder = !_isAscendingOrder;
      _dataList = _isAscendingOrder
          ? _dataList.reversed.toList()
          : _dataList.reversed.toList();
    });
    // 保存用户设置
    StorageForBool.setData('sortOrder', _isAscendingOrder);
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
        actions: [
          //搜素按钮
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          //添加
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final re = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddNotePage()));
              if (re != null) {
                _loadData();
              }
            },
          ),
          //显示更多按钮
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(_isCompactMode
                        ? Icons.view_comfortable
                        : Icons.view_agenda),
                    title: Text(_isCompactMode ? '宽松模式' : '紧凑模式'),
                    onTap: () {
                      setState(() {
                        // _isCompactMode = !_isCompactMode;
                        _toggleCompactMode();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                      leading: Icon(_isAscendingOrder
                          ? Icons.arrow_upward
                          : Icons.arrow_downward),
                      title: Text(_isAscendingOrder ? '正序' : '倒序'),
                      onTap: () {
                        setState(() {
                          _toggleSortOrder();
                        });
                        Navigator.pop(context);
                      }),
                ),
                //按时间排序，根据item['time'] 排序
              ];
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 根据约束宽度动态计算列数
          int crossAxisCount;
          if (_isCompactMode) {
            // 紧凑模式
            // crossAxisCount = constraints.maxWidth > 400 ? 3 : 2;
            //满足不同的宽度，显示不同的列数
            if (constraints.maxWidth > 1800) {
              crossAxisCount = 7;
            } else if (constraints.maxWidth > 1200) {
              crossAxisCount = 5;
            } else if (constraints.maxWidth > 800) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 400) {
              crossAxisCount = 3;
            } else {
              crossAxisCount = 3;
            }
          } else {
            // 宽松模式
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
                                color: Colors.black,
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
                              style: TextStyle(
                                fontSize: _isCompactMode ? 9 : 12, // 紧凑模式字体更小
                                color: Colors.grey,
                              ),
                            ),
                            // if (item['Tag'] != null && item['Tag'].isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _isCompactMode
                                    ? item['Tag'].length > 3
                                        ? "${item['Tag'].substring(0, 2)}"
                                        : item['Tag']
                                    : item['Tag'].length > 3
                                        ? "${item['Tag'].substring(0, 3)}.."
                                        : item['Tag'],
                                style: TextStyle(
                                  fontSize: _isCompactMode ? 9 : 12, // 紧凑模式字体更小
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
