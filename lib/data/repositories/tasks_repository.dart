import 'package:meta/meta.dart';
import 'package:re_nest/data/database/moor_database.dart';

class TasksRepository {
  TasksRepository({@required this.database});

  final AppDatabase database;

  Future<List<Task>> loadTasks() => database.getAllTasks();

  Future addTask(Task task) => database.insertTask(task);

  Future updateTask(Task task) => database.updateTask(task);
}
