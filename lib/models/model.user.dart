class UserData {
  String? _uid;
  String? _email;
  String? _username;
  String? _phone;
  String? _firstName;
  String? _lastName;
  String? _location;
  String? _dob;
  String? _imgUri;
  String? _ts;

  UserData(
      {String? uid,
      String? email,
      String? username,
      String? phone,
      String? firstName,
      String? lastName,
      String? location,
      String? dob,
      String? imgUri,
      String? ts}) {
    if (uid != null) {
      _uid = uid;
    }
    if (email != null) {
      _email = email;
    }
    if (username != null) {
      _username = username;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (firstName != null) {
      _firstName = firstName;
    }
    if (lastName != null) {
      _lastName = lastName;
    }
    if (location != null) {
      _location = location;
    }
    if (dob != null) {
      _dob = dob;
    }
    if (imgUri != null) {
      _imgUri = imgUri;
    }
    if (ts != null) {
      _ts = ts;
    }
  }

  String? get uid => _uid;
  set uid(String? uid) => _uid = uid;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get username => _username;
  set username(String? username) => _username = username;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get firstName => _firstName;
  set firstName(String? firstName) => _firstName = firstName;
  String? get lastName => _lastName;
  set lastName(String? lastName) => _lastName = lastName;
  String? get location => _location;
  set location(String? location) => _location = location;
  String? get dob => _dob;
  set dob(String? dob) => _dob = dob;
  String? get imgUri => _imgUri;
  set imgUri(String? imgUri) => _imgUri = imgUri;
  String? get ts => _ts;
  set ts(String? ts) => _ts = ts;

  UserData.fromJson(Map<String, dynamic> json) {
    _uid = json['uid'];
    _email = json['email'];
    _username = json['username'];
    _phone = json['phone'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _location = json['location'];
    _dob = json['dob'];
    _imgUri = json['img_uri'];
    _ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = _uid;
    data['email'] = _email;
    data['username'] = _username;
    data['phone'] = _phone;
    data['first_name'] = _firstName;
    data['last_name'] = _lastName;
    data['location'] = _location;
    data['dob'] = _dob;
    data['img_uri'] = _imgUri;
    data['ts'] = _ts;
    return data;
  }
}
