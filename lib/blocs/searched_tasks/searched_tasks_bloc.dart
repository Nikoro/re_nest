import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:re_nest/blocs/searched_tasks/searched_tasks_event.dart';
import 'package:re_nest/blocs/searched_tasks/searched_tasks_state.dart';
import 'package:re_nest/blocs/tasks/tasks_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_state.dart';
import 'package:re_nest/data/database/moor_database.dart';

class SearchedTasksBloc extends Bloc<SearchedTasksEvent, SearchedTasksState> {
  SearchedTasksBloc({@required this.tasksBloc}) : super(SearchedTasksEmpty()) {
    tasksSubscription = tasksBloc.listen((state) {
      if (state is TasksLoadSuccess) {
        add(TasksUpdated((tasksBloc.state as TasksLoadSuccess).tasks));
      }
    });
  }

  final TasksBloc tasksBloc;
  StreamSubscription tasksSubscription;

  @override
  Stream<SearchedTasksState> mapEventToState(SearchedTasksEvent event) async* {
    if (event is TextChanged) {
      yield* _mapTextChangedToState(event);
    } else if (event is TasksUpdated) {
      yield* _mapTasksUpdatedToState(event);
    } else if (event is SearchCancelled) {
      yield SearchedTasksEmpty();
    }
  }

  Stream<SearchedTasksState> _mapTextChangedToState(TextChanged event) async* {
    final String query = event.query;
    if (query.isEmpty) {
      yield SearchedTasksEmpty();
    } else if (tasksBloc.state is TasksLoadSuccess) {
      final tasks = (tasksBloc.state as TasksLoadSuccess).tasks;
      final result = _mapTasksToSearchedTasks(tasks, query);
      yield SearchedTasksLoadSuccess(result, query);
    }
  }

  Stream<SearchedTasksState> _mapTasksUpdatedToState(
      TasksUpdated event) async* {
    final query = state is SearchedTasksLoadSuccess
        ? (state as SearchedTasksLoadSuccess).query
        : '';

    if (query.isEmpty) {
      yield SearchedTasksEmpty();
    } else {
      final tasks = (tasksBloc.state as TasksLoadSuccess).tasks;
      final result = _mapTasksToSearchedTasks(tasks, query);
      yield SearchedTasksLoadSuccess(result, query);
    }
  }

  List<Task> _mapTasksToSearchedTasks(List<Task> tasks, String query) {
    return tasks
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    return super.close();
  }
}
