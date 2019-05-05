import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Select Active Hours"),
            Container(
                decoration: BoxDecoration(
                    border: new Border.all(color: Colors.grey[400]),
                    borderRadius: new BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Start Time"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 25,
                          width: 100,
                          decoration: BoxDecoration(
                              border: new Border.all(color: Colors.grey),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5))),
                        ),
                        Container(
                          height: 25,
                          width: 100,
                          decoration: BoxDecoration(
                              border: new Border.all(color: Colors.grey),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5))),
                        ),
                        Container(
                          height: 25,
                          width: 100,
                          decoration: BoxDecoration(
                              border: new Border.all(color: Colors.grey),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5))),
                        ),
                      ],
                    ),
                    Divider(),
                    Text("Start Time"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 25,
                          width: 100,
                          decoration: BoxDecoration(
                              border: new Border.all(color: Colors.grey),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5))),
                        ),
                        Container(
                          height: 25,
                          width: 100,
                          decoration: BoxDecoration(
                              border: new Border.all(color: Colors.grey),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5))),
                        ),
                        Container(
                          height: 25,
                          width: 100,
                          decoration: BoxDecoration(
                              border: new Border.all(color: Colors.grey),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5))),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
