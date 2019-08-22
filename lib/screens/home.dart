import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            new RaisedMenuButton(
                buttonIcon: Icon(Icons.playlist_add),
                buttonName: "Add Word",
                pressButton: () {
                  print("add word");
                  Navigator.pushNamed(context, '/add_word');
                }),
            Container(
              height: 20,
            ),
            new RaisedMenuButton(
                buttonIcon: Icon(Icons.menu),
                buttonName: "Show Words",
                pressButton: () {
                  print("show word list");
                  Navigator.pushNamed(context, '/word_list');
                }),
            Container(
              height: 20,
            ),
            new RaisedMenuButton(
              buttonIcon: Icon(Icons.settings),
              buttonName: "Settings",
              pressButton: () {
                print("settings");
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settngs")),
        ],
        fixedColor: Colors.deepPurple,
        onTap: (i) {
          print(i);
          if (i == 0) {
            Navigator.pushNamed(context, '/');
          } else {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

typedef PressButton = void Function();

class RaisedMenuButton extends StatelessWidget {
  const RaisedMenuButton({
    Key key,
    @required this.buttonIcon,
    @required this.buttonName,
    @required this.pressButton,
  }) : super(key: key);

  final Icon buttonIcon;
  final String buttonName;
  final PressButton pressButton;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: pressButton,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
          width: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
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
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buttonIcon,
              Container(
                width: 10,
              ),
              Center(
                  child: Text(
                buttonName,
                style: TextStyle(fontSize: 18),
              )),
            ],
          )),
    );
  }
}
