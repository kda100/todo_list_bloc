import 'dart:async';
import 'package:todolist/blocs/base_bloc.dart';
import 'package:todolist/blocs/save_todo_list/save_todo_list_events.dart';
import 'package:todolist/blocs/save_todo_list/save_todo_list_states.dart';
import 'package:todolist/repositories/todo_list_repo.dart';

class SaveTodoListBloc extends BaseBloc<SaveTodoListState, SaveTodoListEvent> {
  final TodoListRepo _todoListRepo = TodoListRepo();

  ///function used to save the current state of the todoList onto firestore, by communication with firebase service.
  void _onSaveTodoListEvent() async {
    try {
      await _todoListRepo.saveTodoList();
      addState(SuccessSaveTodoListState());
    } catch (e) {
      addState(ErrorSaveTodoListState());
    }
  }

  @override
  mapEventToState(event) {
    _onSaveTodoListEvent();
  }
}
