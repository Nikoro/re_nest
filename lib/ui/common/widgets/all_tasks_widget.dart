import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_nest/data/database/moor_database.dart';
import 'package:re_nest/data/models/priority.dart';

import 'completed_tasks_tile.dart';
import 'not_completed_tasks_tile.dart';

class AllTasksWidget extends StatelessWidget {
  const AllTasksWidget({
    Key key,
    @required this.tasks,
  }) : super(key: key);

  final List<Task> tasks;

  List<Widget> _generateListOfItemsBasedOn(List<Task> tasks) {
    List<Widget> items = [];

    for (Priority priority in Priority.values) {
      final notCompletedTasksWithSpecificPriority =
          tasks.where((task) => !task.isCompleted && task.priority == priority);
      if (notCompletedTasksWithSpecificPriority.length > 0) {
        items.add(_Header(priority: priority));
        items.addAll(notCompletedTasksWithSpecificPriority
            .map((task) => NotCompletedTaskTile(
                  task: task,
                )));
      }
    }

    final completedTasks = tasks.where((task) => task.isCompleted);
    items.addAll(completedTasks.map((task) => CompletedTaskTile(
          task: task,
        )));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _generateListOfItemsBasedOn(tasks);
    return Material(
      child: Container(
        color: const Color(0xFFF4F7FA),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key key, this.priority}) : super(key: key);

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 15, 0, 10),
      child: Text(
        '${priority.value} PRIORITY',
        style: TextStyle(color: priority.color),
      ),
    );
  }
}
