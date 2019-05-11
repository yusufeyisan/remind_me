import 'package:flutter/material.dart';

class AddWordPage extends StatefulWidget {
  @override
  _AddWordPageState createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  var _textController = TextEditingController();

  updateFields({w: "", f: "", s: "", t: ""}) {
    setState(() {
      _word = w;
      _first = f;
      _second = s;
      _third = t;
    });
  }

  resetFields() {
    updateFields();
    _formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Word',
            ),
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
              decoration: const InputDecoration(
                labelText: 'First Meaning',
              ),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'First mean is required';
                } else if (!validCharacters.hasMatch(value.trim())) {
                  return "Invalid characters";
                }
                updateFields(w: _word, f: value, s: _second, t: _third);
              }),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Second Meaning',
            ),
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Invalid caracters';
              }
              updateFields(w: _word, f: _first, s: value, t: _third);
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Third Meaning',
            ),
            validator: (String value) {
              if (value.trim().isNotEmpty &&
                  !validCharacters.hasMatch(value.trim())) {
                return 'Third meaning is required';
              }
              updateFields(w: _word, f: _first, s: _second, t: value);
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

  void _submit() {
    _formKey.currentState.validate();
  }
}
