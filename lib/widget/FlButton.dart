import 'package:days/pages/common.dart';
import 'package:days/pages/commonnote.dart';
import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

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
        tooltip: S.of(context).Add,
        child: Row(
          children: [
            const SizedBox(width: 10), // 添加间距
            Text(S.of(context).Add),
            const Icon(Icons.add),
          ],
        )),
  );
}

Widget AddNote(context, Function ref) {
  return FloatingActionButton(
    onPressed: () async {
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AddNotePage()));
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
