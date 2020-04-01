import '../data/database_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/models/setting.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

const String EndDateHour = "eh";
const String StartDateHour = "sh";
const String EndDateMinute = "em";
const String StartDateMinute = "sm";

class _SettingsPageState extends State<SettingsPage> {
  final formKey = GlobalKey<FormState>();

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

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
  Setting settingModel;

  int _enabled = 0;
  int _weekend = 0;
  int _workDays = 0;
  String _endDate = DateTime.now().add(Duration(hours: 8)).toString();
  String _startDate = DateTime.now().toString();
  String _startWeek = "Monday";

  var weekDays = <String>[
    "Monday",
    "Thuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
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
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Activate Notifications",
                          style: headerStyle,
                        ),
                        buildSwitchRow("Enabled", _enabled),
                        Divider(),
                        Text(
                          "Select Active Days",
                          style: headerStyle,
                        ),
                        buildStartWeekRow("Start Week", _startWeek),
                        buildSwitchRow("Weekdays", _workDays),
                        buildSwitchRow("Weekend", _weekend),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Set Active Hours",
                          style: headerStyle,
                        ),
                        buildActiveHoursRow(_startDate, _endDate),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                                padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                                onPressed: submitForm,
                                color: Colors.blue,
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                )))));
  }

  Future<int> getSettingId() async {
    final allRows = await dbHelper.getAllSettings();
    var settingModels =
        allRows.map((setting) => Setting.fromJson(setting)).toList();
    if (settingModels.length > 0) {
      return settingModels[settingModels.length - 1].id;
    }
    return 0;
  }

  void submitForm() {
    final form = formKey.currentState;
    if (!form.validate()) {
      print("invalid form data");
    }
    setState(() {
      form.save();
      getSettingId().then((id) {
        if (id != 0) {
          print("update stage: " + id.toString());
          updateSettings(id);
          return;
        }

        print("insert stage");
        insertSettings();
        return;
      });
    });
  }

  void insertSettings() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.sColumnWeekend: this._weekend,
      DatabaseHelper.sColumnEnabled: this._enabled,
      DatabaseHelper.sColumnEndDate: this._endDate,
      DatabaseHelper.sColumnWorkDays: this._workDays,
      DatabaseHelper.sColumnStartDate: this._startDate,
      DatabaseHelper.sColumnStartWeek: this._startWeek,
    };
    final id = await dbHelper.insertSetting(row);
    formKey.currentState.reset();
    print('Inserted row id: $id');
  }

  void updateSettings(int _id) async {
    Setting setting = new Setting(_id, this._enabled, this._startDate,
        this._endDate, this._workDays, this._startWeek, this._weekend);

    final id = await dbHelper.updateSetting(setting);
    formKey.currentState.reset();
    print('updated row id: $id');
  }

// returns a row with switch buttom
  Container buildSwitchRow(String name, int value) {
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
                value: (value == 0) ? false : true,
                dragStartBehavior: DragStartBehavior.start,
                onChanged: (v) {
                  var m = settingModel;

                  switch (name) {
                    case "Enabled":
                      m.enabled = v ? 1 : 0;
                      setState(() {
                        _enabled = m.enabled;
                      });
                      break;
                    case "WeekDays":
                      m.workDays = v ? 1 : 0;
                      setState(() {
                        _workDays = m.workDays;
                      });
                      break;
                    case "Weekend":
                      m.weekend = v ? 1 : 0;
                      setState(() {
                        _weekend = m.weekend;
                      });
                      break;
                    default:
                  }
                  setState(() {
                    settingModel = m;
                  });
                },
                activeColor: Colors.green,
              )),
        ],
      ),
    );
  }

// returns a row with switch buttom
  Container buildActiveHoursRow(String start, end) {
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "From",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm ${date.toString()}');
                      setState(() {
                        _startDate = date.toString();
                      });
                    },
                        currentTime:
                            DateTime.now()); //DateTime.parse(_startDate));
                  },
                ),
                Container(
                  child: Text(
                    _startDate.substring(10, 19),
                    style: labelStyle,
                  ),
                  padding: EdgeInsets.all(10),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "To",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm ${date.toString()}');
                      setState(() {
                        _endDate = date.toString();
                      });
                    },
                        currentTime:
                            DateTime.now()); // DateTime.parse(_endDate));
                  },
                ),
                Container(
                  child: Text(
                    _endDate.substring(10, 19),
                    style: labelStyle,
                  ),
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

// returns a "start week" label and swich button row
  Container buildStartWeekRow(String name, String day) {
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
            elevation: 8,
            isExpanded: false,
            value: day,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (v) {
              updateSelectedDropdownValue(v);
            },
            items: weekDays.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  child: Text(value),
                  padding: EdgeInsets.only(
                    left: 25,
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() async {
    print("resfresh data");
    final allRows = await dbHelper.getAllSettings();
    var settingModels =
        allRows.map((setting) => Setting.fromJson(setting)).toList();

    setState(() {
      if (settingModels.length > 0) {
        settingModel = null;
        this.settingModel = settingModels[settingModels.length - 1];
      }
    });

    setState(() {
      // set form fields
      _endDate = settingModel.endDate;
      _startDate = settingModel.startDate;
      _startWeek = settingModel.startWeek;
      _enabled = settingModel.enabled;
      _weekend = settingModel.weekend;
      _workDays = settingModel.workDays;
    });
  }

  void updateSelectedDropdownValue(String v) {
    setState(() {
      _startWeek = v;
    });
  }
}
