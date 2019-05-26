import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';
import '../data/database_helper.dart';
import 'dart:async';

class EditWordPage extends StatefulWidget {
  final Word wordObject;

  // In the constructor, require a Todo
  EditWordPage({Key key, @required this.wordObject}) : super(key: key);

  @override
  _EditWordPageState createState() => _EditWordPageState(wordObject);
}

class _EditWordPageState extends State<EditWordPage> {
  final wordObject;
  _EditWordPageState(this.wordObject);
  //_EditWordPageState(this.WordObject)

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Edit New Word "),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: RegisterForm(wordObject: this.wordObject),
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  final Word wordObject;
  const RegisterForm({Key key, @required this.wordObject}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState(wordObject);
}

class _RegisterFormState extends State<RegisterForm> {
  final Word wordObject;
  _RegisterFormState(this.wordObject);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  static final validCharacters = RegExp(r'^[a-zA-Z0-9ğüşöçİĞÜŞÖÇ]+$');
  String _word = "";
  String _first = "";
  String _second = "";
  String _third = "";
  String _synonyms = "";
  bool _active = true;
  int _priority = 0;

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
        updateWord();
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
            initialValue: widget.wordObject.word,
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Word is required';
              } else if (!validCharacters.hasMatch(value.trim())) {
                return "Invalid characters";
              }
              updateFields(w: value, f: _first, s: _second, t: _third);
            },
          ),
          const SizedBox(height: 10.0),
          Divider(),
          const SizedBox(height: 10.0),
          TextFormField(
              onSaved: (val) => _first = val,
              decoration: const InputDecoration(labelText: 'First Meaning'),
              initialValue: widget.wordObject.first,
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'First mean is required';
                } else if (!validCharacters.hasMatch(value.trim())) {
                  return "First mean is invalid";
                }
                updateFields(
                    w: _word, f: value, s: _second, t: _third, sy: _synonyms);
              }),
          const SizedBox(height: 10.0),
          TextFormField(
            onSaved: (val) => _second = val,
            decoration: const InputDecoration(
              labelText: 'Second Meaning',
            ),
            initialValue: widget.wordObject.second,
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Second means is invalid';
              }
              updateFields(
                  w: _word, f: _first, s: value, t: _third, sy: _synonyms);
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            onSaved: (val) => _third = val,
            decoration: const InputDecoration(
              labelText: 'Third Meaning',
            ),
            initialValue: widget.wordObject.third,
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Third meaning is invalid';
              }
              updateFields(
                  w: _word, f: _first, s: _second, t: value, sy: _synonyms);
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            onSaved: (val) => _synonyms = val,
            decoration: const InputDecoration(
              labelText: 'Synonyms',
            ),
            initialValue: widget.wordObject.synonyms,
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Synonym fied contains invalid characters';
              }
              updateFields(
                  w: _word, f: _first, s: _second, t: _third, sy: value);
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

  void updateWord() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: this.wordObject.id,
      DatabaseHelper.columnWord: this._word,
      DatabaseHelper.columnFirst: this._first,
      DatabaseHelper.columnSecond: this._second,
      DatabaseHelper.columnThird: this._third,
      DatabaseHelper.columnSynonyms: this._synonyms,
      DatabaseHelper.columnActive: this._active,
      DatabaseHelper.columnPriority: this._priority
    };
    final id = await dbHelper.update(row);
    _formKey.currentState.reset();
    print('inserted row id: $id');
  }
}
