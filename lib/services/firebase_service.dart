import 'package:todolist/models/todo_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/constants/firebase.dart';

///Firebase Service serves as a direct API between the app and the firestore database.
///The service moves data to and from the provider model when the provider requests it.

class FirebaseServices {
  //Singleton class.
  static final FirebaseServices _instance = FirebaseServices._();

  FirebaseServices._();

  factory FirebaseServices() {
    return _instance;
  }

  final CollectionReference todoListColRef = FirebaseFirestore.instance.collection(
      todoListColPath); //collection ref where todoItems are stored in firestore.

  String get getNewId =>
      todoListColRef.doc().id; //getter to get unique id for todoItem.

  ///function loads todoList from firebase when provide requests it and converts them into TodoItem objects.
  ///This is then communicated to the provider model.
  Future<List<QueryDocumentSnapshot<Object?>>> loadTodoList() async {
    return (await todoListColRef
            .orderBy(
              dateField,
            )
            .get())
        .docs;
  }

  Future<void> deleteTodoItem(String id) async {
    await todoListColRef.doc(id).delete();
  }

  Future<void> setTodoItem(String id, Map<String, dynamic> data) async {
    await todoListColRef.doc(id).set(data);
  }
}
