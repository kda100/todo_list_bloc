import 'package:flutter/material.dart';
import 'package:todolist/blocs/save_todo_list/save_todo_list_bloc.dart';
import 'package:todolist/blocs/save_todo_list/save_todo_list_events.dart';
import 'package:todolist/blocs/save_todo_list/save_todo_list_states.dart';
import 'package:todolist/blocs/todo_list/todo_list_bloc.dart';
import 'package:todolist/blocs/todo_list/todo_list_events.dart';
import 'package:todolist/blocs/todo_list/todo_list_states.dart';
import 'package:todolist/constants/strings.dart';
import 'package:todolist/models/todo_item_action.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/todo_item_screen.dart';
import '../widgets/todo_list_tile_widget.dart';

///main todoList screen that presents to the user all the todoItems.
///Its gives the user the ability to add new items, edit items, delete them and save the current state
///of the todolist.

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late SaveTodoListBloc _saveTodoListBloc;
  late TodoListBloc _todoListBloc;

  @override
  void initState() {
    _saveTodoListBloc = Provider.of<SaveTodoListBloc>(context, listen: false);
    _todoListBloc = Provider.of<TodoListBloc>(context, listen: false);
    _todoListBloc.addEvent(
      InitTodoListEvent(),
    );
    _saveTodoListBloc.stateStream.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(event.message),
          duration: const Duration(seconds: 1),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TodoItemScreen(
                        todoItemAction: TodoItemAction.add),
                  ),
                );
              },
              icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () async {
              _saveTodoListBloc.addEvent(SaveTodoListEvent());
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: StreamBuilder<TodoListState>(
          stream: _todoListBloc.stateStream,
          initialData: TodoListState([]),
          builder: (context, snap) {
            final TodoListState todoListState = snap.data!;
            return ListView.builder(
              itemCount: todoListState.numTodoListItems,
              itemBuilder: (context, index) => TodoListTile(
                todoListState.todoItemViewModel(index: index),
              ),
              physics: const BouncingScrollPhysics(),
            );
          }),
    );
  }
}
