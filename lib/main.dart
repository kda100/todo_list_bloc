import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:todolist/blocs/load_todo_list/load_todo_list_bloc.dart';
import 'package:todolist/blocs/todo_list/todo_list_bloc.dart';
import 'package:todolist/screens/todo_list_screen_builder.dart';
import 'constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const TodolistApp());
}

///main app.
class TodolistApp extends StatelessWidget {
  const TodolistApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MultiProvider(
        providers: [
          Provider(
            create: (context) => LoadTodoListBloc(),
          ),
          Provider(
            create: (context) => TodoListBloc(),
          ),
        ],
        child: MaterialApp(
          title: appTitle,
          theme: ThemeData(
            splashColor: Colors.transparent,
            colorScheme:
                Theme.of(context).colorScheme.copyWith(primary: Colors.black),
            appBarTheme: const AppBarTheme(
              //global app theme.
              color: Colors.black,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          home: const TodoListScreenBuilder(),
        ),
      ),
    );
  }
}
