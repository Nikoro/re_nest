import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_nest/blocs/searched_tasks/searched_tasks_bloc.dart';
import 'package:re_nest/blocs/searched_tasks/searched_tasks_event.dart';
import 'package:re_nest/blocs/searched_tasks/searched_tasks_state.dart';
import 'package:re_nest/blocs/tasks/tasks_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_state.dart';
import 'package:re_nest/ui/common/routes/slide_from_bottom_route.dart';
import 'package:re_nest/ui/common/widgets/all_tasks_widget.dart';
import 'package:re_nest/ui/common/widgets/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  static Route<dynamic> route() {
    return SlideFromBottomRoute(SearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        border: null,
        automaticallyImplyLeading: false,
        middle: _SearchFiled(),
        trailing: _CancelButton(),
      ),
      child: SafeArea(
        child: BlocListener(
          cubit: BlocProvider.of<TasksBloc>(context),
          listener: (context, state) {
            if (state is TasksLoadSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            color: const Color(0xFFF4F7FA),
            child: BlocBuilder<SearchedTasksBloc, SearchedTasksState>(
              builder: (context, state) {
                if (state is SearchedTasksEmpty) {
                  return Center(child: Text('Search'));
                }
                if (state is SearchedTasksLoadInProgress) {
                  return const LoadingIndicator();
                }
                if (state is SearchedTasksLoadSuccess) {
                  return AllTasksWidget(
                    tasks: state.searchedTasks,
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchFiled extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF4F7FA),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        autofocus: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 10),
          border: InputBorder.none,
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Colors.grey,
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              CupertinoIcons.clear_circled_solid,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {
              _controller.clear();
              BlocProvider.of<SearchedTasksBloc>(context)
                  .add(SearchCancelled());
            },
          ),
        ),
        onChanged: (text) {
          BlocProvider.of<SearchedTasksBloc>(context).add(TextChanged(text));
        },
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(left: 5),
      child: const Text('Cancel'),
      onPressed: () {
        BlocProvider.of<SearchedTasksBloc>(context).add(SearchCancelled());
        Navigator.of(context).pop();
      },
    );
  }
}
