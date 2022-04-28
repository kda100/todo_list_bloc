import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/blocs/load_todo_list/load_todo_list_bloc.dart';
import 'package:todolist/blocs/load_todo_list/load_todo_list_events.dart';
import 'package:todolist/blocs/load_todo_list/load_todo_list_states.dart';
import 'package:todolist/blocs/save_todo_list/save_todo_list_bloc.dart';
import 'package:todolist/blocs/todo_list/todo_list_bloc.dart';
import 'package:todolist/blocs/todo_list/todo_list_states.dart';
import 'package:todolist/screens/placeholder_screen.dart';
import 'package:todolist/screens/todo_list_screen.dart';

///Contains a future builder to build the correct screens during when the app
///is downloading todoItems from firebase.

class TodoListScreenBuilder extends StatefulWidget {
  const TodoListScreenBuilder({Key? key}) : super(key: key);

  @override
  State<TodoListScreenBuilder> createState() => _TodoListScreenBuilderState();
}

class _TodoListScreenBuilderState extends State<TodoListScreenBuilder> {
  late LoadTodoListBloc _loadTodoListBloc;

  @override
  void initState() {
    _loadTodoListBloc = Provider.of<LoadTodoListBloc>(
      context,
      listen: false,
    );
    _loadTodoListBloc.addEvent(LoadTodoListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadTodoListState>(
      stream: _loadTodoListBloc.stateStream, //initialise todoList.
      initialData: LoadingTodoListState(),
      builder: (context, snap) {
        final LoadTodoListState loadTodoListState = snap.data!;
        if (loadTodoListState is LoadingTodoListState) {
          return const PlaceholderScreen(
            placeholder: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (loadTodoListState is ErrorLoadTodoListState) {
          return const PlaceholderScreen(
            placeholder: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Provider(
            create: (BuildContext context) => SaveTodoListBloc(),
            child: const TodoListScreen(),
          );
        }
      },
    );
  }
}
