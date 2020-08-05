import 'package:re_nest/data/database/moor_database.dart';

abstract class TasksState {
  const TasksState();
}

class TasksLoadInProgress extends TasksState {}

class TasksLoadSuccess extends TasksState {
  const TasksLoadSuccess([this.tasks = const []]);

  final List<Task> tasks;
}

class TasksLoadFailure extends TasksState {}
