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

  bool enabled = false;
  int selectedEndHour = 0;
  int selectedEndMinute = 0;
  int selectedStartHour = 0;
  int selectedStartMinute = 0;

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
            body: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text("General Notifications"),
                      buildGeneralSetting(),
                      Divider(),
                      Text("Select Active Hours"),
                      AbsorbPointer(
                        absorbing: !enabled,
                        ignoringSemantics: false,
                        child: buildNotifyTimeSetting(),
                      )
                    ],
                  ),
                ))));
  }

// returns a "Enabled" labels and swich buttom
  Container buildGeneralSetting() {
    return Container(
      decoration: BoxDecoration(
        border: new Border.all(color: Colors.grey[400]),
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Enabled"),
          Expanded(
            child: Container(
              width: double.maxFinite,
            ),
          ),
          Container(
              child: Switch(
            value: enabled,
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

// returns start and end date of notify
  Container buildNotifyTimeSetting() {
    return Container(
        decoration: BoxDecoration(
            border: new Border.all(color: Colors.grey[400]),
            borderRadius: new BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Start Time"),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text("Hour"),
                ),
                Container(
                  width: 100,
                  child: Text("Minute"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  child: getDropdownItems(hours, StartDateHour),
                ),
                Container(
                  width: 100,
                  child: getDropdownItems(minutes, StartDateMinute),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text("End Time"),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text("Hour"),
                ),
                Container(
                  width: 100,
                  child: Text("Minute"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  child: getDropdownItems(hours, EndDateHour),
                ),
                Container(
                  width: 100,
                  child: getDropdownItems(minutes, EndDateMinute),
                ),
              ],
            ),
          ],
        ));
  }

// returns dropdowns of hour andminutes
  DropdownButton<int> getDropdownItems(List<int> itemList, String s) {
    return DropdownButton(
        isDense: false,
        elevation: 10,
        isExpanded: true,
        value: (s == StartDateHour
            ? selectedStartHour
            : (s == StartDateMinute
                ? selectedStartMinute
                : (s == EndDateHour ? selectedEndHour : selectedEndMinute))),
        icon: Icon(Icons.arrow_drop_down),
        items: itemList.map((int v) {
          return new DropdownMenuItem<int>(
            value: v,
            child: Text(
              v.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (v) {
          updateSelectedDropdownValue(s, v);
        });
  }

  void updateSelectedDropdownValue(String selector, int v) {
    setState(() {
      switch (selector) {
        case StartDateHour:
          selectedStartHour = v;
          break;
        case StartDateMinute:
          selectedStartMinute = v;
          break;
        case EndDateHour:
          selectedEndHour = v;
          break;
        case EndDateMinute:
          selectedEndMinute = v;
          break;
        default:
      }
    });
  }

  getSelectedDropdownValue(String s) {
    setState(() {
      switch (s) {
        case StartDateHour:
          return selectedStartHour;
        case StartDateHour:
          return selectedStartMinute;
        case EndDateHour:
          return selectedEndHour;
        case EndDateMinute:
          return selectedEndMinute;
        default:
      }
    });
  }
}
