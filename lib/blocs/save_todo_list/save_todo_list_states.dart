abstract class SaveTodoListState {
  final String message;

  SaveTodoListState(this.message);
}

class SuccessSaveTodoListState extends SaveTodoListState {
  SuccessSaveTodoListState() : super("Todo List saved successfully.");
}

class ErrorSaveTodoListState extends SaveTodoListState {
  ErrorSaveTodoListState() : super("An error occurred saving todo list.");
}
