class Setting {
  int _id;
  int _enabled;
  String _startDate;
  String _endDate;
  int _workDays;

// constracture
  Setting(
    this._enabled,
    this._startDate,
    this._endDate,
    this._workDays
  );

  // set model fields
  Setting.map(dynamic obj) {
    this._id = obj["_id"];
    this._enabled = obj["enabled"];
    this._startDate = obj["startDate"];
    this._endDate = obj["endDate"];
    this._workDays = obj["workDays"];
  }

  // get model fields
  int get id => _id;
  int get enabled => _enabled;
  String get startDate => _startDate;
  String get endDate => _endDate;
  int get workDays => _workDays;

  // get model fields

  set id(int value) => _id = value;
  set enabled(int value) => _enabled = value;
  set startDate(String value) => _startDate = value;
  set endDate(String value) => _endDate = value;
  set workDays(int value) => _workDays = value;

  // model to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["_id"] = _id;
    map["enabled"] = _enabled;
    map["startDate"] = _startDate;
    map["endDate"] = _endDate;
    map["workDate"] = _workDays;
    return map;
  }

  Setting.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._enabled = map['endabled'];
    this._startDate = map['startDate'];
    this._endDate = map['endDate'];
    this._workDays = map['workDays'];
  }

  Setting.fromJson(Map json)
      : _id = json['_id'],
        _enabled = json['enabled'],
        _startDate = json['startDate'],
        _endDate = json['endDate'],
        _workDays = json['workDate'];

  Map toJson() {
    return {
      '_id': _id,
      'enabled': _enabled,
      'startDate': _startDate,
      'endDate': _endDate,
      'workDays': _workDays,
    };
  }
}
