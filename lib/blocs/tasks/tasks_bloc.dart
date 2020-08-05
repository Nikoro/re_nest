import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:re_nest/blocs/tasks/tasks_event.dart';
import 'package:re_nest/blocs/tasks/tasks_state.dart';
import 'package:re_nest/data/repositories/tasks_repository.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({@required this.tasksRepository}) : super(TasksLoadInProgress());

  final TasksRepository tasksRepository;

  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if (event is TasksLoaded) {
      yield* _mapTasksLoadedToState();
    } else if (event is TaskAdded) {
      yield* _mapTaskAddedToState(event);
    } else if (event is TaskCompleted) {
      yield* _mapTaskCompletedToState(event);
    }
  }

  Stream<TasksState> _mapTasksLoadedToState() async* {
    try {
      final tasks = await tasksRepository.loadTasks();
      yield TasksLoadSuccess(
        tasks,
      );
    } catch (_) {
      yield TasksLoadFailure();
    }
  }

  Stream<TasksState> _mapTaskAddedToState(TaskAdded event) async* {
    await tasksRepository.addTask(event.task);
    final tasks = await tasksRepository.loadTasks();
    yield TasksLoadSuccess(tasks);
  }

  Stream<TasksState> _mapTaskCompletedToState(TaskCompleted event) async* {
    final completedTask = event.task.copyWith(isCompleted: true);
    await tasksRepository.updateTask(completedTask);
    final tasks = await tasksRepository.loadTasks();
    yield TasksLoadSuccess(tasks);
  }
}
