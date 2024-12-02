import 'package:days/pages/add.dart';
import 'package:days/pages/addnote.dart';
import 'package:days/pages/common.dart';
import 'package:flutter/material.dart';

Widget flbutton(context, Function loadData) {
  return SizedBox(
    width: 70,
    child: FloatingActionButton(
        onPressed: () async {
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

Widget AddNote(context, Function ref) {
  return FloatingActionButton(
    onPressed: () async {
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const addnotepage()));
      if (result == true) {
        ref();
      }
    },
    child: const Icon(Icons.add),
  );
}

Widget SaveNote(context, Function SaveData) {
  return FloatingActionButton(
    onPressed: () {
      // Add your onPressed code here!
      SaveData();
    },
    // backgroundColor: Colors.green,
    child: const Icon(Icons.save),
  );
}
