import 'dart:async';

import 'package:todolist/blocs/base_bloc.dart';
import 'package:todolist/blocs/load_todo_list/load_todo_list_events.dart';
import 'package:todolist/blocs/load_todo_list/load_todo_list_states.dart';

import '../../repositories/todo_list_repo.dart';

class LoadTodoListBloc extends BaseBloc<LoadTodoListState, LoadTodoListEvent> {
  final TodoListRepo _todoListRepo = TodoListRepo();

  ///function used to save the current state of the todoList onto firestore, by communication with firebase service.
  void _onLoadTodoListEvent() async {
    try {
      await _todoListRepo.initTodoList();
      addState(SuccessLoadTodoListState());
    } catch (e) {
      addState(ErrorLoadTodoListState());
    }
  }

  @override
  mapEventToState(LoadTodoListEvent event) {
    _onLoadTodoListEvent();
  }
}
