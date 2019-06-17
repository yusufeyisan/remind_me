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
            child: RegisterForm(
              id: this.id,
            ),
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  final int id;
  const RegisterForm({Key key, @required this.id}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState(id);
}

class _RegisterFormState extends State<RegisterForm> {
  int id;
  _RegisterFormState(this.id);
  Word editWord;
  String _word;
  String _first;
  String _second;
  String _third;
  String _synonyms;
  bool _active;
  int _priority;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWord(id);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  static final validCharacters = RegExp(r'^[a-zA-Z0-9ğüşöçİĞÜŞÖÇ]+$');

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

  void getWord(int id) async {
    final w = await dbHelper.getWord(id);
    setState(() {
      this.editWord = new Word(
        w.word,
        w.first,
        w.second,
        w.third,
        w.synonyms,
        w.active,
        w.priority,
      );
      editWord.id = w.id;
      updateFields();
    });
    print(this._word);
    _formKey.currentState.setState(() {
      this._word = w.word;
      this._first = w.first;
      this._second = w.second;
      this._third = w.third;
      this._synonyms = w.second;
      this._priority = w.priority;
      this._active = w.active == 1 ? true : false;
    });
  }

  void updateWord() async {
    // row to update

    editWord.word = this._word;
    editWord.first = this._first;
    editWord.second = this._second;
    editWord.third = this._third;
    editWord.synonyms = this._synonyms;

    final id = await dbHelper.update(editWord);
    setState(() {
      Word w;
      editWord = w;
    });
    _formKey.currentState.reset();
    print('updated row id: $id');
  }
}
