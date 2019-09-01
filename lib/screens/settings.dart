import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

const String EndDateHour = "eh";
const String StartDateHour = "sh";
const String EndDateMinute = "em";
const String StartDateMinute = "sm";

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  TextStyle headerStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  TextStyle labelStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  bool enabled = false;
  int selectedEndHour = 0;
  int selectedEndMinute = 0;
  int selectedStartHour = 0;
  int selectedStartMinute = 0;
  String selectedDay = "Monday";

  var weekDays = <String>[
              "Monday",
              "Thuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday",
              "Sunday",
            ];
// generate hours
  List<int> hours = () {
    List<int> v = [];
    for (var i = 0; i < 24; i++) {
      v.add(i);
    }
    return v;
  }();

// generate minutes
  List<int> minutes = () {
    List<int> v = [];
    for (var i = 0; i < 60; i++) {
      v.add(i);
    }
    return v;
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Settings",
                      style: TextStyle(
                          letterSpacing: 1.2,
                          color: Colors.black87,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Container(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Activate Notifications",
                        style: headerStyle,
                      ),
                      buildSwitchRow("Enabled"),
                      Divider(),
                      Text(
                        "Select Active Days",
                        style: headerStyle,
                      ),
                      buildStartWeekRow("Start Week"),
                      buildSwitchRow("Weekdays"),
                      buildSwitchRow("Weekend"),
                    ],
                  ),
                )))));
  }

// returns a row with switch buttom
  Container buildSwitchRow(String name) {
    return Container(
      decoration: BoxDecoration(
        border: new Border.all(color: Colors.grey[400]),
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            style: labelStyle,
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
            ),
          ),
          Transform.scale(
              scale: 1.3,
              child: Switch(
                value: enabled,
                dragStartBehavior: DragStartBehavior.start,
                onChanged: (v) {
                  setState(() {
                    enabled = v;
                  });
                },
                activeColor: Colors.green,
              )),
        ],
      ),
    );
  }

// returns a "start week" label and swich button row
  Container buildStartWeekRow(String name) {
    return Container(
      decoration: BoxDecoration(
        border: new Border.all(color: Colors.grey[400]),
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            style: labelStyle,
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
            ),
          ),
          DropdownButton(
            isDense: false,
            elevation: 1,
            isExpanded: false,
            value: selectedDay,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (v) {
             updateSelectedDropdownValue(v);
            },
            items: <String>[
              "Monday",
              "Thuesday",
              "Wednesday",
              "Thursday",
              "Friday",
              "Saturday",
              "Sunday",
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }


  void updateSelectedDropdownValue( String v) {
    setState(() {
      selectedDay = v;
    });
  }

  getSelectedDropdownValue(String s) {
    setState(() {
      
    });
  }
}
