import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';
import '../data/database_helper.dart';
import 'dart:async';

class AddWordPage extends StatefulWidget {
  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "Add Word",
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
            child: RegisterForm(),
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  static final validCharacters = RegExp(r'^[a-zA-Z0-9 ğüşöçıİĞÜŞÖÇ]*$');

  int _priority = 0;
  bool _active = true;

  String _word = "";
  String _first = "";
  String _third = "";
  String _second = "";
  String _synonyms = "";

  updateFields({w: "", f: "", s: "", t: "", sy: ""}) {
    setState(() {
      _word = w;
      _first = f;
      _second = s;
      _third = t;
      _synonyms = sy;
    });
  }

  resetFields() {
    updateFields();
    _formKey.currentState.reset();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        form.save();
        _insertWord();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            onSaved: (val) => _word = val,
            decoration: InputDecoration(labelText: 'Word'),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Word is required';
              } else if (!validCharacters.hasMatch(value.trim())) {
                return "Invalid characters";
              }
              updateFields(w: value, f: _first, s: _second, t: _third);
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          Divider(),
          const SizedBox(height: 10.0),
          TextFormField(
              onSaved: (val) => _first = val,
              decoration: const InputDecoration(labelText: 'First Meaning'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'First mean is required';
                } else if (!validCharacters.hasMatch(value.trim())) {
                  return "First mean is invalid";
                }
                updateFields(
                    w: _word, f: value, s: _second, t: _third, sy: _synonyms);
                return null;
              }),
          const SizedBox(height: 10.0),
          TextFormField(
            onSaved: (val) => _second = val,
            decoration: const InputDecoration(
              labelText: 'Second Meaning',
            ),
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Second means is invalid';
              }
              updateFields(
                  w: _word, f: _first, s: value, t: _third, sy: _synonyms);
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            onSaved: (val) => _third = val,
            decoration: const InputDecoration(
              labelText: 'Third Meaning',
            ),
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Third meaning is invalid';
              }
              updateFields(
                  w: _word, f: _first, s: _second, t: value, sy: _synonyms);
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            onSaved: (val) => _synonyms = val,
            decoration: const InputDecoration(
              labelText: 'Synonyms',
            ),
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Synonym fied contains invalid characters';
              }
              updateFields(
                  w: _word, f: _first, s: _second, t: _third, sy: value);
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              OutlineButton(
                highlightedBorderColor: Colors.red,
                onPressed: () {
                  resetFields();
                },
                child: const Text('Clean'),
              ),
              const Spacer(),
              OutlineButton(
                highlightedBorderColor: Colors.green,
                onPressed: _submittable() ? _submit : null,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _submittable() {
    return true;
  }

  void _insertWord() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.wColumnWord: this._word,
      DatabaseHelper.wColumnFirst: this._first,
      DatabaseHelper.wColumnSecond: this._second,
      DatabaseHelper.wColumnThird: this._third,
      DatabaseHelper.wColumnSynonyms: this._synonyms,
      DatabaseHelper.wColumnActive: this._active,
      DatabaseHelper.wColumnPriority: this._priority
    };
    final id = await dbHelper.insertWord(row);
    _formKey.currentState.reset();
    print('Inserted row id: $id');
  }
}
