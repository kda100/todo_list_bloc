import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo_item.dart';
import '../services/firebase_service.dart';

class TodoListRepo {
  //Singleton class.
  static final TodoListRepo _instance = TodoListRepo._();

  TodoListRepo._();

  factory TodoListRepo() {
    return _instance;
  }

  final FirebaseServices _firebaseServices = FirebaseServices();
  final List<TodoItem> _todoList = []; //stores TodoItems.
  final List<String> _deletedTodoIds =
      []; //ids of TodoItems to be deleted from firebase.

  List<TodoItem> get todoList => _todoList;

  Future<void> initTodoList() async {
    List<QueryDocumentSnapshot<Object?>> firestoreQuerySnaps =
        await _firebaseServices.loadTodoList();
    firestoreQuerySnaps.forEach(
      (firestoreQuerySnap) {
        final Map<String, dynamic> data =
            firestoreQuerySnap.data() as Map<String, dynamic>;
        _todoList.add(TodoItem.fromFirestore(firestoreQuerySnap.id, data));
      },
    );
  }

  ///function saves current state of todoList. It takes in the current todoList and a list of deleted todoIds.
  Future<void> saveTodoList() async {
    for (String id in _deletedTodoIds) {
      //each id is deleted if it is in firestore.
      await _firebaseServices.deleteTodoItem(id);
    }
    _deletedTodoIds
        .clear(); //clear deletedTodoIds so delete attempt is not made again.
    for (TodoItem todoItem in _todoList) {
      if (todoItem.edited) {
        //only todoItems that have been edited/added are written to firestore.
        await _firebaseServices.setTodoItem(
            todoItem.id, todoItem.toFirestore());
        todoItem.edited =
            false; //ensure todoEdit is false so it is not written again.
      }
    }
  }

  ///function used to sort todoList so the items are orders in descending times.
  void _sortTodoList() {
    _todoList.sort(
      (a, b) => a.date.millisecondsSinceEpoch
          .compareTo(b.date.millisecondsSinceEpoch),
    );
  }

  ///function adds a new item to the todoList.
  void addTodoItem(
      {required String title,
      required String description,
      required DateTime date}) {
    final String id = _firebaseServices.getNewId;
    _todoList.add(
      TodoItem(
        id: id,
        title: title,
        description: description,
        date: date,
      ),
    );
    _sortTodoList(); //sort needed after addition to maintain the order.
  }

  ///removes item from todoList using the items index in the list.
  void deleteTodoItem({required int index}) {
    _deletedTodoIds.add(_todoList[index].id);
    _todoList.removeAt(index);
  }

  ///function used to update TodoItem in todo list.
  void updateTodoItem({
    required int index,
    required String newTitle,
    required String newDescription,
    required DateTime newDate,
  }) {
    final TodoItem todoItem = _todoList[index];
    final bool isSameMoment = todoItem.date.isAtSameMomentAs(newDate);
    if (todoItem.title != newTitle ||
        todoItem.description != newDescription ||
        !isSameMoment) {
      //checks if any of the date has changed before changing todoitem.
      _todoList[index] = todoItem.copyWith(
        newTitle: newTitle,
        newDescription: newDescription,
        newDate: newDate,
      );
      if (!isSameMoment) {
        _sortTodoList(); //sort to maintain order of list
      }
    }
  }
}
