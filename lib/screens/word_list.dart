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

final TextStyle wordStyle = TextStyle(
  fontSize: 18,
  letterSpacing: 1,
  color: Colors.white,
);
final TextStyle meansStyle = TextStyle(
  fontSize: 15,
  letterSpacing: 1,
  color: Colors.white,
);

final TextStyle synonymStyle = TextStyle(
  color: Colors.white70,
  fontSize: 15,
  letterSpacing: 1,
);

class _WordListPageState extends State<WordListPage> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;
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
                        letterSpacing: 1.2,
                        color: Colors.black87,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ];
          },
          body: new ListView.builder(
              itemCount: getWordCount(),
              itemBuilder: (BuildContext context, int index) {
                print("hello empty world");
                return Dismissible(
                  direction: (items[index].active == 0
                      ? DismissDirection.horizontal
                      : DismissDirection.startToEnd),
                  background: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: new BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    //  color: Colors.orangeAccent,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Edit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: new BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 10),
                        Icon(Icons.delete, color: Colors.white)
                      ],
                    ),
                  ),
                  key: new Key(items[index].id.toString()),
                  dragStartBehavior: DragStartBehavior.down,
                  confirmDismiss: (direction) async {
                    return await buildShowDialog(context, direction);
                  },
                  onDismissed: (direction) {
                    onDissmissed(direction, index, context);
                  },
                  child: Card(
                    child: Container(
                        height: 80.0,
                        color: Colors.teal[400],
                        margin: new EdgeInsets.all(0.0),
                        child: buildItemRow(index)),
                  ),
                );
              })),
    );
  }

  Row buildWordRow(int index) {
    var word = items[index].word.toLowerCase();
    word = word[0].toUpperCase() + word.substring(1);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Word: ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "$word",
          style: wordStyle,
        ),
      ],
    );
  }

  String toUpperFirstChar(String value) {
    if (value.length == 0) {
      return value;
    }
    value = value[0].toUpperCase() + value.substring(1);
    return value;
  }

  Row buildMeansRow(int index) {
    var means = "";
    if (items[index].first.length > 0) {
      means = toUpperFirstChar(items[index].first) + "\t";
    }
    if (items[index].second.length > 0) {
      means += "-\t" + toUpperFirstChar(items[index].second) + "\t";
    }
    if (items[index].third.length > 0) {
      means += "-\t" + toUpperFirstChar(items[index].third) + "\t";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "Means: ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$means",
          style: meansStyle,
        ),
      ],
    );
  }

  Row buildSynonymRow(int index) {
    var synonym = items[index].synonyms;
    if (synonym.length == 0) {
      return Row();
    }
    synonym = toUpperFirstChar(synonym);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          "Synonym: ",
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          "$synonym",
          style: synonymStyle,
        ),
      ],
    );
  }

  Row buildItemRow(int index) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildWordRow(index),
              buildMeansRow(index),
              buildSynonymRow(index)
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  var s = items[index].active == 1 ? 0 : 1;
                  update(index, s);
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: items[index].active == 1
                      ? Icon(
                          Icons.check,
                          size: 30.0,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          size: 30.0,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void onDissmissed(
      DismissDirection direction, int index, BuildContext context) {
    if (direction.index == 2) {
      delete(items[index].id);
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Word deleted successfully."),
      ));
    } else {
      var data = items[index];
      setState(() {
        items.remove(items[index]);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditWordPage(word: data),
        ),
      ).then((cntx) {
        refreshData();
      });
    }
  }

  Future<bool> buildShowDialog(
      BuildContext context, DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: direction.index == 2
                ? Text("Do you want to delete this item?")
                : Text("Do you want to edit this item?"),
            actions: <Widget>[
              RaisedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: direction.index == 2 ? Text("DELETE") : Text("EDIT")),
              RaisedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() async {
    final allRows = await dbHelper.getAllWords();
    setState(() {
      items = [];
      items = allRows.map((word) => Word.fromJson(word)).toList();
    });
  }

  void update(int id, active) async {
    Word word = items[id];
    word.active = active;

    // Update row
    await dbHelper.updateWord(word);
    refreshData();
  }

  void delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    await dbHelper.deleteWord(id);
    refreshData();
  }

  // return length of items array
  int getWordCount() {
    return items.length;
  }
}
