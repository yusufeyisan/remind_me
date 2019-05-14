import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';
import '../data/database_helper.dart';
import 'dart:async';

class AddWordPage extends StatefulWidget {
  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  final ScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ScaffoldKey,
        appBar: AppBar(
          title: Text("Add New Word"),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
        saveWord();
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

  void saveWord() async {
    var W = Word(
      this._word,
      this._first,
      this._second,
      this._third,
      this._synonyms,
      this._active,
      this._priority,
    );

    var db = DatabaseHelper();
    await db.saveWord(W);
    _formKey.currentState.reset();
  }

  void _showSnackBar(String text) {
    var a = _AddWordPageState();
    var scfKey = a.ScaffoldKey;

    scfKey.currentState.showSnackBar(SnackBar(
      content: Text("$text added successfully"),
    ));
  }
}
