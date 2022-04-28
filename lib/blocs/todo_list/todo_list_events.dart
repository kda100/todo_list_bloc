import 'package:todolist/models/todo_item.dart';

abstract class TodoListEvent {}

class InitTodoListEvent extends TodoListEvent {}

class AddTodoItemEvent extends TodoListEvent {
  final String title;
  final String description;
  final DateTime date;

  AddTodoItemEvent({
    required this.title,
    required this.description,
    required this.date,
  });
}

class DeleteTodoItemEvent extends TodoListEvent {
  final int index;

  DeleteTodoItemEvent({required this.index});
}

class UpdateTodoItemEvent extends TodoListEvent {
  final int index;
  final String newTitle;
  final String newDescription;
  final DateTime newDate;

  UpdateTodoItemEvent({
    required this.index,
    required this.newTitle,
    required this.newDescription,
    required this.newDate,
  });
}
