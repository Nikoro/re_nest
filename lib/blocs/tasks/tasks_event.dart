import 'package:re_nest/data/database/moor_database.dart';

abstract class TasksEvent {
  const TasksEvent();
}

class TasksLoaded extends TasksEvent {}

class TaskAdded extends TasksEvent {
  const TaskAdded(this.task);

  final Task task;
}

class TaskCompleted extends TasksEvent {
  const TaskCompleted(this.task);

  final Task task;
}
