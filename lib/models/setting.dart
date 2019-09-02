class Setting {
  int _id;
  int _enabled;
  String _startDate;
  String _endDate;
  int _workDays;
  String _startWeek;
  int _weekend;

// constracture
  Setting(
    this._enabled,
    this._startDate,
    this._endDate,
    this._workDays,
    this._startWeek,
    this._weekend,
  );

  // set model fields
  Setting.map(dynamic obj) {
    this._id = obj["_id"];
    this._weekend = obj["weekend"];
    this._enabled = obj["enabled"];
    this._endDate = obj["endDate"];
    this._workDays = obj["workDays"];
    this._startWeek = obj["startWeek"];
    this._startDate = obj["startDate"];
  }

  // get model fields
  int get id => _id;
  int get weekend => _weekend;
  int get enabled => _enabled;
  int get workDays => _workDays;
  String get endDate => _endDate;
  String get startDate => _startDate;
  String get startWeek => _startWeek;

  // get model fields

  set id(int value) => _id = value;
  set weekend(int value) => _weekend = value;
  set enabled(int value) => _enabled = value;
  set workDays(int value) => _workDays = value;
  set endDate(String value) => _endDate = value;
  set startDate(String value) => _startDate = value;
  set startWeek(String value) => _startWeek = value;

  // model to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["_id"] = _id;
    map["weekend"] = _weekend;
    map["enabled"] = _enabled;
    map["endDate"] = _endDate;
    map["workDays"] = _workDays;
    map["startDate"] = _startDate;
    map["startWeek"] = _startWeek;
    return map;
  }

  Setting.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._weekend = map['weekend'];
    this._endDate = map['endDate'];
    this._enabled = map['endabled'];
    this._workDays = map['workDays'];
    this._startWeek = map['startWeek'];
    this._startDate = map['startDate'];
  }

  Setting.fromJson(Map json)
      : _id = json['_id'],
        _weekend = json['weekend'],
        _enabled = json['enabled'],
        _endDate = json['endDate'],
        _workDays = json['workDays'],
        _startDate = json['startDate'],
        _startWeek = json['startWeek'];

  Map toJson() {
    return {
      '_id': _id,
      'weekend':_weekend,
      'enabled': _enabled,
      'endDate': _endDate,
      'workDays': _workDays,
      'startDate': _startDate,
      'startWeek': _startWeek,
    };
  }
}
