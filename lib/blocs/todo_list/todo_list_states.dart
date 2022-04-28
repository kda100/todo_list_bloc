import 'package:todolist/models/todo_item.dart';

import '../../models/todo_item_view_model.dart';

class TodoListState {
  final List<TodoItem> todoList;

  TodoListState(this.todoList);

  int get numTodoListItems => todoList.length;

  TodoItemViewModel todoItemViewModel({required index}) {
    return TodoItemViewModel(
      index: index,
      todoItem: todoList[index],
    );
  }
}
