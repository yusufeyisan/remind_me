import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';
import '../data/database_helper.dart';
import 'dart:async';

class EditWordPage extends StatefulWidget {
  // final Word wordObject;
  final int id;
  // In the constructor, require a Todo
  EditWordPage({Key key, @required this.id}) : super(key: key);

  @override
  _EditWordPageState createState() => _EditWordPageState(id);
}

class _EditWordPageState extends State<EditWordPage> {
  final id;
  _EditWordPageState(this.id);
  //_EditWordPageState(this.WordObject)
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    // TODO: implement initState
    // TODO: db den id ile veri çek
    super.initState();

  }

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
  Word wordObject;
  _RegisterFormState(this.wordObject);

  @override
  void initState() {
    print("Edit - " + wordObject.id.toString() + " - " + wordObject.word);
    // TODO: implement initState
    super.initState();
    _word = wordObject.word;
    _first = wordObject.first;
    _second = wordObject.second;
    _third = wordObject.third;
    _synonyms = wordObject.synonyms;
  }

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
            initialValue: _word,
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
              initialValue: _first,
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
            initialValue: _second,
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
            initialValue: _third,
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
            initialValue: _synonyms,
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
                onPressed: _submittable()
                    ? () async {
                        Navigator.pop(context);
                        _submit();
                      }
                    : null,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

  void _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      setState(() async {
        form.save();
        updateWord();
      });
    }
  }

  bool _submittable() {
    return true;
  }

  void updateWord() async {
    // row to update
    wordObject.word = this._word;
    wordObject.first = this._first;
    wordObject.second = this._second;
    wordObject.third = this._third;
    wordObject.synonyms = this._synonyms;

    final id = await dbHelper.update(wordObject);
    setState(() {
      Word w;
      wordObject = w;
    });
    _formKey.currentState.reset();
    print('updated row id: $id');
  }
}
