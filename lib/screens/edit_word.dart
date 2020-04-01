import '../data/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';

class EditWordPage extends StatefulWidget {
  // final Word wordObject;
  final Word word;
  // In the constructor, require a Todo
  EditWordPage({Key key, @required this.word}) : super(key: key);

  @override
  _EditWordPageState createState() => _EditWordPageState(word);
}

class _EditWordPageState extends State<EditWordPage> {
  Word word;
  _EditWordPageState(this.word);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController wordController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController thirdController = TextEditingController();
  TextEditingController synonymController = TextEditingController();

  @override
  void initState() {
    wordController.text = word.word;
    firstController.text = word.first;
    secondController.text = word.second;
    thirdController.text = word.third;
    synonymController.text = word.synonyms;
    super.initState();
  }

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  static final validCharacters = RegExp(r'^[a-zA-Z0-9 ğüşöçıİĞÜŞÖÇ]*$');
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
                      "Edit Word",
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
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          //    onSaved: (val) => _word = val,
                          decoration: InputDecoration(
                              labelText: 'Word',
                              labelStyle: TextStyle(color: Colors.grey)),
                          //   initialValue: _word,
                          controller: wordController,
                          validator: (String value) {
                            print("66:" + value);
                            if (value.trim().isEmpty) {
                              return 'Word is required';
                            } else if (!validCharacters
                                .hasMatch(value.trim())) {
                              return "Invalid characters";
                            }
                            var w = word;
                            w.word = value;
                            setState(() {
                              word = w;
                            });
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Divider(),
                        const SizedBox(height: 10.0),
                        TextFormField(
                            onSaved: (val) => word.first = val,
                            decoration: const InputDecoration(
                                labelText: 'First Meaning',
                                labelStyle: TextStyle(color: Colors.grey)),
                            // initialValue: _first,
                            controller: firstController,
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'First mean is required';
                              } else if (!validCharacters
                                  .hasMatch(value.trim())) {
                                return "First mean is invalid";
                              }
                              var w = word;
                              w.first = value;
                              setState(() {
                                word = w;
                              });
                              return null;
                            }),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          onSaved: (val) => word.second = val,
                          decoration: const InputDecoration(
                              labelText: 'Second Meaning',
                              labelStyle: TextStyle(color: Colors.grey)),
                          //  initialValue: _second,
                          controller: secondController,
                          validator: (String value) {
                            if (value.trim().isNotEmpty &&
                                !validCharacters.hasMatch(value.trim())) {
                              return 'Second means is invalid';
                            }
                            var w = word;
                            w.second = value;
                            setState(() {
                              word = w;
                            });
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          onSaved: (val) => word.third = val,
                          decoration: const InputDecoration(
                              labelText: 'Third Meaning',
                              labelStyle: TextStyle(color: Colors.grey)),
                          // initialValue: _third,
                          controller: thirdController,
                          validator: (String value) {
                            if (value.trim().isNotEmpty &&
                                !validCharacters.hasMatch(value.trim())) {
                              return 'Third meaning is invalid';
                            }
                            var w = word;
                            w.third = value;
                            setState(() {
                              word = w;
                            });
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          onSaved: (val) => word.synonyms = val,
                          decoration: const InputDecoration(
                              labelText: 'Synonyms',
                              labelStyle: TextStyle(color: Colors.grey)),
                          //   initialValue: _synonyms,
                          controller: synonymController,
                          validator: (String value) {
                            if (value.trim().isNotEmpty &&
                                !validCharacters.hasMatch(value.trim())) {
                              return 'Synonym fied contains invalid characters';
                            }
                            var w = word;
                            w.synonyms = value;
                            setState(() {
                              word = w;
                            });
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
                              onPressed: _submittable()
                                  ? () async {
                                      var result = await _submit();
                                      if (result) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  : null,
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            )));
  }

  resetFields() {
    setState(() {
      wordController.text = "";
      firstController.text = "";
      secondController.text = "";
      thirdController.text = "";
      synonymController.text = "";
    });
  }

  Future<bool> _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      updateWord();
      return true;
    } else {
      print("object yusuf");
      return false;
    }
  }

  bool _submittable() {
    return true;
  }

  void updateWord() async {
    final id = await dbHelper.updateWord(word);
    print('updated row id: $id');
  }
}
