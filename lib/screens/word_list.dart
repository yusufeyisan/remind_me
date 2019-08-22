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
  color: Colors.blue,
  fontSize: 18,
);
final TextStyle descriptionStyle = TextStyle(
  fontSize: 15,
  letterSpacing: 1,
);
final TextStyle synonymStyle = TextStyle(
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
                          Text("Edit",
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
                    child: buildItemRow(index));
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
          "Word: $word index:$index id:${items[index].id}",
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
          "Means: $means",
          style: descriptionStyle,
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
          "Synonym: $synonym",
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
        print("send edit word index:$index\n");
      int id = items[index].id;
        print("send edit word id:$id\n");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditWordPage(id: id),
        ),
      );
      setState(() {
        items.remove(items[index]);
      });
      refreshData();
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
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      items = [];
      items = allRows.map((word) => Word.fromJson(word)).toList();
    });
  }

  void update(int id, active) async {
    print("object");
    Word word = items[id];
    word.active = active;

    // Update row
    await dbHelper.update(word);
    refreshData();
  }

  void delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    await dbHelper.delete(id);
    refreshData();
  }

  // return length of items array
  int getWordCount() {
    return items.length;
  }
}
