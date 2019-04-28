import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminde Me"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: 175,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: <Color>[
                      Color(0xFF38326D),
                      Color(0xFF6158B9),
                      Color(0xFF38326D),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Center(
                    child: Text(
                  'Upload File',
                  style: TextStyle(fontSize: 18),
                )),
              ),
            ),
            Container(
              height: 15,
            ),
            RaisedButton(
              onPressed: () {},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: 175,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: <Color>[
                      Color(0xFF38326D),
                      Color(0xFF6158B9),
                      Color(0xFF38326D),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Center(
                    child: Text(
                  'Add Word',
                  style: TextStyle(fontSize: 18),
                )),
              ),
            ),
            Container(
              height: 15,
            ),
            RaisedButton(
              onPressed: () {},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: 175,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: <Color>[
                      Color(0xFF38326D),
                      Color(0xFF6158B9),
                      Color(0xFF38326D),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Center(
                    child: Text(
                  'Show Words',
                  style: TextStyle(fontSize: 18),
                )),
              ),
            ),
            Container(
              height: 15,
            ),
            RaisedButton(
              onPressed: () {},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: 175,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: <Color>[
                      Color(0xFF38326D),
                      Color(0xFF6158B9),
                      Color(0xFF38326D),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Center(
                    child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 18),
                )),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
