import 'package:days/pages/add.dart';
import 'package:days/pages/common.dart';
import 'package:flutter/material.dart';

Widget flbutton(context, Function loadData) {
  return SizedBox(
    width: 70,
    child: FloatingActionButton(
        onPressed: () async {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => addpage()),
          // );
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEditcommon()));

          if (result == true) {
            loadData();
            // Navigator.pop(context);
          }
        },
        tooltip: '添加',
        child: const Row(
          children: [
            SizedBox(width: 10), // 添加间距
            Text("添加"),
            Icon(Icons.add),
          ],
        )),
  );
}

Widget AddnoteFlButton() {
  return FloatingActionButton(
    onPressed: () {
      // Add your onPressed code here!
    },
    backgroundColor: Colors.green,
    child: const Icon(Icons.save),
  );
}
