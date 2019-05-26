import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';
import '../data/database_helper.dart';
import '../screens/edit_word.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  final TextStyle wordStyle = TextStyle(color: Colors.blue, fontSize: 18);
  final TextStyle descriptionStyle = TextStyle(fontSize: 15, letterSpacing: 1);
  final TextStyle synonymStyle =
      TextStyle(fontSize: 15, fontStyle: FontStyle.italic, letterSpacing: 1);

  List<Word> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Word List",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: new ListView.builder(
              itemCount: getWordCount(),
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    direction: (items[index].active == 0
                        ? DismissDirection.horizontal
                        : DismissDirection.startToEnd),
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20.0),
                      color: Colors.orangeAccent,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 10),
                          Text("Do you want to edit it?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      color: Colors.redAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("Do you want to delete it?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(width: 10),
                          Icon(Icons.delete, color: Colors.white)
                        ],
                      ),
                    ),
                    key: new Key(items[index].word),
                    dragStartBehavior: DragStartBehavior.down,
                    confirmDismiss: (direction) async {
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: direction.index == 2
                                  ? Text(
                                      "Are you sure you wish to delete this item?")
                                  : Text(
                                      "Are you sure you wish to edit this item?"),
                              actions: <Widget>[
                                RaisedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: direction.index == 2
                                        ? Text("DELETE")
                                        : Text("EDIT")),
                                RaisedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"))
                              ],
                            );
                          });
                      return res;
                    },
                    onDismissed: (direction) {
                      if (direction.index == 2) {
                        print("delete");
                        delete(index);
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("Word deleted successfully"),
                        ));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditWordPage(
                                  wordObject: items[index],
                                ),
                          ),
                        );
                        print("length: " + items.length.toString());
                        print("index: " + index.toString());
                        print("name: " + items[index].word);
                        setState(() {
                          items.remove(items[index]);
                        });
                        query();
                      }
                    },
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Word: ${items[index].word}",
                                    style: wordStyle,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Means: ${items[index].first}\t-\t" +
                                        "${items[index].second}\t-\t" +
                                        "${items[index].third}",
                                    style: descriptionStyle,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Synonym: ${items[index].synonyms}",
                                    style: synonymStyle,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Checkbox(
                              value: items[index].active == 1 ? true : false,
                              activeColor: Colors.green,
                              onChanged: (b) {
                                // update function takes index and value of active
                                update(index, (b ? 1 : 0));
                              },
                            )
                          ],
                        )
                      ],
                    ));
              })),
    );
  }

  @override
  void initState() {
    super.initState();
    query();
  }

  void query() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      items = allRows.map((word) => Word.fromJson(word)).toList();
    });
  }

  void update(int id, int active) async {
    var word = items[id];

    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: word.id,
      DatabaseHelper.columnWord: word.word,
      DatabaseHelper.columnFirst: word.first,
      DatabaseHelper.columnSecond: word.second,
      DatabaseHelper.columnThird: word.third,
      DatabaseHelper.columnSynonyms: word.synonyms,
      DatabaseHelper.columnActive: active,
      DatabaseHelper.columnPriority: word.priority
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
    query();
  }

  void delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    query();
  }

  // return length of items array
  int getWordCount() {
    return items.length;
  }
}
