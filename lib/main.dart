import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_nest/data/database/moor_database.dart';
import 'package:re_nest/data/repositories/tasks_repository.dart';
import 'package:re_nest/ui/screens/home_screen.dart';

import 'blocs/searched_tasks/searched_tasks_bloc.dart';
import 'blocs/tasks/tasks_bloc.dart';
import 'blocs/tasks/tasks_event.dart';

void main() {
  final tasksRepository = TasksRepository(
    database: AppDatabase(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (context) => TasksBloc(
            tasksRepository: tasksRepository,
          )..add(TasksLoaded()),
        ),
        BlocProvider<SearchedTasksBloc>(
          create: (context) => SearchedTasksBloc(
            tasksBloc: BlocProvider.of<TasksBloc>(context),
          ),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white),
    );

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      title: 'ReNest',
      theme: const CupertinoThemeData(primaryColor: Colors.black),
      home: HomeScreen(),
    );
  }
}
