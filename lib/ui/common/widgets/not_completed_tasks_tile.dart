import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_event.dart';
import 'package:re_nest/data/database/moor_database.dart';

class NotCompletedTaskTile extends StatelessWidget {
  const NotCompletedTaskTile({Key key, this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          title: Text(
            task.title,
          ),
          leading: Icon(
            CupertinoIcons.circle,
            size: 40,
          ),
          onTap: () {
            BlocProvider.of<TasksBloc>(context).add(TaskCompleted(task));
          },
        ),
      ),
    );
  }
}
