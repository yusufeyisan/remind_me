import 'package:flutter/material.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class Words {
  String word;
  String first;
  String second;
  String third;
  String synonym;
  bool completed;
  Words(this.word, this.first, this.second, this.third,this.synonym, this.completed);
}

class _WordListPageState extends State<WordListPage> {
  final TextStyle wordStyle = TextStyle(color: Colors.blue, fontSize: 18);
  final TextStyle descriptionStyle = TextStyle(fontSize: 15, letterSpacing: 1);
  final TextStyle synonymStyle = TextStyle(fontSize: 15,fontStyle: FontStyle.italic, letterSpacing: 1);

  List<Words> items = [
    //new Words("Happy", "Mutlu", "Neşeli", "Keyifli", false),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
   Words("Dream", "Rüya", "Düş", "Hayal","delusion", true),
      ];

  update(int index) {
    setState(() {
      items[index].completed = !items[index].completed;
    });
  }

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
                                "Synonym: ${items[index].synonym}",
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
                          value: items[index].completed,
                          activeColor: Colors.green,
                          onChanged: (b) {
                            update(index);
                          },
                        )
                      ],
                    )
                  ],
                );
              })),
    );
  }
}
