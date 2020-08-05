import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_state.dart';
import 'package:re_nest/data/database/moor_database.dart';
import 'package:re_nest/ui/common/widgets/all_tasks_widget.dart';
import 'package:re_nest/ui/common/widgets/completed_tasks_tile.dart';
import 'package:re_nest/ui/common/widgets/loading_indicator.dart';
import 'package:re_nest/ui/screens/search_screen.dart';

import 'add_screen.dart';

class HomeScreen extends StatelessWidget {
  final tabs = ['Tasks', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          border: null,
          middle: const Text(
            'ReNest',
            style: TextStyle(
              color: Color(0xFF32315C),
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          trailing: _AddButton(),
        ),
        child: Material(
          child: SafeArea(
            child: Column(
              children: [
                _SearchButton(),
                _TopNavigationBar(
                  tabs: tabs,
                ),
                Expanded(
                  child: BlocBuilder<TasksBloc, TasksState>(
                    builder: (context, state) {
                      if (state is TasksLoadInProgress) {
                        return const LoadingIndicator();
                      }
                      if (state is TasksLoadSuccess) {
                        return _buildTabsWithData(state.tasks);
                      }
                      if (state is TasksLoadFailure) {
                        return Center(child: Text('Something went wrong'));
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsWithData(List<Task> tasks) {
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    return TabBarView(
      children: [
        AllTasksWidget(
          tasks: tasks,
        ),
        _CompletedTasksWidget(
          completedTasks: completedTasks,
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Icon(
        CupertinoIcons.add,
        size: 40,
      ),
      onPressed: () {
        Navigator.of(context).push(AddScreen.route());
      },
    );
  }
}

class _SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        elevation: 0,
        color: const Color(0xFFF4F7FA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                CupertinoIcons.search,
                color: Colors.blueGrey,
                size: 20,
              ),
            ),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(SearchScreen.route());
        },
      ),
    );
  }
}

class _TopNavigationBar extends StatelessWidget {
  const _TopNavigationBar({@required this.tabs});

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: tabs.map((t) => Tab(text: t)).toList(),
        indicatorColor: Colors.black,
        indicatorWeight: 2,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 70),
      ),
    );
  }
}

class _CompletedTasksWidget extends StatelessWidget {
  const _CompletedTasksWidget({
    Key key,
    @required this.completedTasks,
  }) : super(key: key);

  final List<Task> completedTasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F7FA),
      child: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return CompletedTaskTile(
            task: task,
          );
        },
      ),
    );
  }
}
