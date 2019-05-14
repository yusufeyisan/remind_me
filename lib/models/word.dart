class Word {
  String _word;
  String _first;
  String _second;
  String _third;
  String _synonyms;
  bool _active;
  int _priority;

// constracture
  Word(
    this._word,
    this._first,
    this._second,
    this._third,
    this._synonyms,
    this._active,
    this._priority,
  );

  // set model fields
  Word.map(dynamic obj) {
    this._word = obj["word"];
    this._first = obj["first"];
    this._second = obj["second"];
    this._third = obj["third"];
    this._synonyms = obj["synonyms"];
    this._active = (obj["active"]) == 1 ? true : false;
    this._priority = obj["priority"];
  }

  // get model fields
  String get word => _word;
  String get first => _first;
  String get second => _second;
  String get third => _third;
  String get synonyms => _synonyms;
  bool get active => _active;
  int get priority => _priority;

  // model to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["word"] = _word;
    map["first"] = _first;
    map["second"] = _second;
    map["third"] = _third;
    map["synonyms"] = _synonyms;
    map["active"] = _active ? 1 : 0;
    map["priority"] = _priority;
    return map;
  }
}
