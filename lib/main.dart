import 'package:flutter/material.dart';
import './screens/home.dart';

void main() => runApp(RemindMe());

class RemindMe extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remind Me',
      theme: ThemeData(
          primarySwatch: Colors.yellow),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
