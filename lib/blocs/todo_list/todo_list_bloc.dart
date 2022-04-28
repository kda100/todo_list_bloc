import 'package:todolist/blocs/base_bloc.dart';
import 'package:todolist/repositories/todo_list_repo.dart';
import '../todo_list/todo_list_events.dart';
import '../todo_list/todo_list_states.dart';

class TodoListBloc extends BaseBloc<TodoListState, TodoListEvent> {
  final TodoListRepo _todoListRepo = TodoListRepo();

  @override
  mapEventToState(event) {
    switch (event.runtimeType) {
      case InitTodoListEvent:
        _initTodoList();
        break;
      case AddTodoItemEvent:
        _addTodoItem(event as AddTodoItemEvent);
        break;
      case DeleteTodoItemEvent:
        _deleteTodoItem(event as DeleteTodoItemEvent);
        break;
      case UpdateTodoItemEvent:
        _updateTodoItem(event as UpdateTodoItemEvent);
        break;
      default:
        break;
    }
  }

  void _initTodoList() {
    addState(TodoListState(_todoListRepo.todoList));
  }

  void _addTodoItem(AddTodoItemEvent addTodoItemEvent) {
    _todoListRepo.addTodoItem(
      title: addTodoItemEvent.title,
      description: addTodoItemEvent.description,
      date: addTodoItemEvent.date,
    );
    addState(TodoListState(_todoListRepo.todoList));
  }

  void _deleteTodoItem(DeleteTodoItemEvent deleteTodoItemEvent) {
    _todoListRepo.deleteTodoItem(index: deleteTodoItemEvent.index);
  }

  void _updateTodoItem(UpdateTodoItemEvent updateTodoItemEvent) {
    _todoListRepo.updateTodoItem(
      index: updateTodoItemEvent.index,
      newTitle: updateTodoItemEvent.newTitle,
      newDescription: updateTodoItemEvent.newDescription,
      newDate: updateTodoItemEvent.newDate,
    );
    addState(TodoListState(_todoListRepo.todoList));
  }
}
