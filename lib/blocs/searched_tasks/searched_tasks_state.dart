import 'package:re_nest/data/database/moor_database.dart';

abstract class SearchedTasksState {
  const SearchedTasksState();
}

class SearchedTasksEmpty extends SearchedTasksState {}

class SearchedTasksLoadInProgress extends SearchedTasksState {}

class SearchedTasksLoadSuccess extends SearchedTasksState {
  const SearchedTasksLoadSuccess(
    this.searchedTasks,
    this.query,
  );

  final List<Task> searchedTasks;
  final String query;
}
