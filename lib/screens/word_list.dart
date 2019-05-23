import 'package:flutter/material.dart';
import 'package:remind_me/models/word.dart';
import '../data/database_helper.dart';

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

  List<Word> items = [
    //new Words("Happy", "Mutlu", "Neşeli", "Keyifli", false),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1),
    Word("Dream", "Rüya", "Düş", "Hayal", "delusion", 1, 1)
  ];

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
              itemCount: items.length,
              itemBuilder: (BuildContext ctxt, int index) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Means: ${items[index].first}\t-\t${items[index].second}\t-\t${items[index].third}",
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            _update(index, (b ? 1 : 0));
                            _query();
                          },
                        )
                      ],
                    )
                  ],
                );
              })),
    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      items = allRows.map((word) => Word.fromJson(word)).toList();
    });
  }

  void _update(int id, int active) async {
    var word = items[id];
    var index = id++;
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: index,
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
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
