import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/add_word.dart';
import './screens/word_list.dart';
void main() => runApp(RemindMe());

class RemindMe extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remind Me',
      theme: themeData,
      home: WordListPage(),
    );
  }

  final ThemeData themeData = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textSelectionHandleColor: Colors.black,
        textSelectionColor: Colors.black12,
        cursorColor: Colors.black,
        toggleableActiveColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
}
