import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_nest/data/database/moor_database.dart';

class CompletedTaskTile extends StatelessWidget {
  const CompletedTaskTile({Key key, this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 34),
      title: Text(
        task.title,
        style: TextStyle(
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      ),
      leading: Icon(
        CupertinoIcons.check_mark_circled_solid,
        color: Colors.grey,
        size: 40,
      ),
    );
  }
}
