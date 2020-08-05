import 'package:re_nest/data/database/moor_database.dart';

abstract class SearchedTasksEvent {
  const SearchedTasksEvent();
}

class TextChanged extends SearchedTasksEvent {
  const TextChanged(this.query);

  final String query;
}

class TasksUpdated extends SearchedTasksEvent {
  const TasksUpdated(this.tasks);

  final List<Task> tasks;
}

class SearchCancelled extends SearchedTasksEvent {}
