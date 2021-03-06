class Word {
  int _id;
  String _word;
  String _first;
  String _second;
  String _third;
  String _synonyms;
  int _active;
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
    this._id = obj["_id"];
    this._word = obj["word"];
    this._first = obj["first"];
    this._second = obj["second"];
    this._third = obj["third"];
    this._synonyms = obj["synonyms"];
    this._active = obj["active"];
    this._priority = obj["priority"];
  }

  // get model fields
  int get id => _id;
  String get word => _word;
  String get first => _first;
  String get second => _second;
  String get third => _third;
  String get synonyms => _synonyms;
  int get active => _active;
  int get priority => _priority;

  // get model fields

  set id(int value) => _id = value;
  set word(String value) => _word = value;
  set first(String value) => _first = value;
  set second(String value) => _second = value;
  set third(String value) => _third = value;
  set synonyms(String value) => _synonyms = value;
  set active(int value) => _active = value;
  set priority(int value) => _priority = value;

  // model to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["_id"] = _id;
    map["word"] = _word;
    map["first"] = _first;
    map["second"] = _second;
    map["third"] = _third;
    map["synonyms"] = _synonyms;
    map["active"] = _active;
    map["priority"] = _priority;
    return map;
  }

  Word.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._word = map['word'];
    this._first = map['first'];
    this._second = map['second'];
    this._third = map['third'];
    this._synonyms = map['synonyms'];
    this._priority = map['priority'];
    this._active = map['active'];
  }

  Word.fromJson(Map json)
      : _id = json['_id'],
        _word = json['word'],
        _first = json['first'],
        _second = json['second'],
        _third = json['third'],
        _synonyms = json['synonyms'],
        _active = json['active'],
        _priority = json['priority'];

  Map toJson() {
    return {
      '_id': _id,
      'word': _word,
      'first': _first,
      'second': _second,
      'third': _third,
      'synonyms': _synonyms,
      'active': _active,
      'priority': _priority,
    };
  }
}
