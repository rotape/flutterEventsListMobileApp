class Event {
  String _title;
  String _date;
  String _description;

  Event( this._title,this._date, this._description);

  Event.map(dynamic obj) {
    this._title = obj['title'];
    this._date = obj['date'];
    this._description = obj['description'];
  }

  String get title => _title;
  String get date => _date;
  String get description => _description;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
      map['title'] = _title;
      map['date'] = _date;
      map['description'] = _description;
      return map;
  }

  Event.fromMap(Map<String, dynamic> map) {
    this._title = map['title'];
    this._date = map['date'];
    this._description = map['description'];
  }
}