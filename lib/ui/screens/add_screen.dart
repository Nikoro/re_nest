import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_bloc.dart';
import 'package:re_nest/blocs/tasks/tasks_event.dart';
import 'package:re_nest/blocs/tasks/tasks_state.dart';
import 'package:re_nest/data/database/moor_database.dart';
import 'package:re_nest/data/models/priority.dart';
import 'package:re_nest/extensions/string_extensions.dart';
import 'package:re_nest/ui/common/routes/slide_from_bottom_route.dart';
import 'package:re_nest/ui/common/widgets/button.dart';

class AddScreen extends StatelessWidget {
  static Route<dynamic> route() {
    return SlideFromBottomRoute(AddScreen());
  }

  final _options = [
    'Book professional movers',
    'Prepare the house',
    'Review moving plans',
    'Prepare for payment',
    'Pack an essentials box',
    'Prepare appliances',
    'Measure furniture and doorways',
    'Take measurements',
    'Order supplies',
    'Begin packing',
    'Do a change of address'
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          border: null,
          middle: const Text(
            'Add Task',
            style: TextStyle(
              color: Color(0xFF32315C),
              fontSize: 20,
            ),
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.left_chevron,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        child: SafeArea(
          child: BlocListener(
            cubit: BlocProvider.of<TasksBloc>(context),
            listener: (context, state) {
              if (state is TasksLoadSuccess) {
                Navigator.of(context).pop();
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.transparent,
              ),
              itemCount: _options.length,
              itemBuilder: (context, index) =>
                  _TaskTile(title: _options[index]),
            ),
          ),
        ));
  }
}

class _TaskTile extends StatefulWidget {
  const _TaskTile({@required this.title});

  final String title;

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<_TaskTile> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 4, 4, 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FA),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isOpen ? _buildOpenedItem() : _buildClosedItem()),
    );
  }

  Widget _buildOpenedItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...Priority.values.map(
          (p) => _PriorityButton(
            priority: p,
            onPressed: () {
              _addNewTask(widget.title, p);
            },
          ),
        ),
        Button(
          icon: CupertinoIcons.clear,
          color: Colors.grey,
          onPressed: () {
            setState(
              () {
                isOpen = false;
              },
            );
          },
        ),
      ],
    );
  }

  void _addNewTask(String title, Priority priority) {
    final task = Task(title: title, priority: priority);
    BlocProvider.of<TasksBloc>(context).add(TaskAdded(task));
  }

  Widget _buildClosedItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.title),
        Button(
          icon: CupertinoIcons.add,
          onPressed: () {
            setState(() {
              isOpen = true;
            });
          },
        ),
      ],
    );
  }
}

class _PriorityButton extends StatelessWidget {
  const _PriorityButton({
    @required this.priority,
    this.onPressed,
  });

  final Priority priority;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            priority.value.toLowerCase().capitalize,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          const Text(
            'Priority',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      color: priority.color,
      textColor: Colors.white,
      onPressed: onPressed,
    );
  }
}
