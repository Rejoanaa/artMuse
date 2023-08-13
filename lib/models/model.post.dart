// ignore_for_file: unnecessary_getters_setters

import 'package:flutter_application_1/models/model.user.dart';

class Post {
  String? _postId;
  String? _email;
  String? _caption;
  String? _imgUri;
  int? _numOfLikes;
  int? _numOfDislikes;
  int? _numOfComments;
  String? _category;
  String? _ts;
  List<Liker>? _liker;
  List<Disliker>? _disliker;
  List<Commenter>? _commenter;
  UserData? _users;
  bool? _likedStatus;
  // int? _numOfRatings;
  int? _ratingValue;
  double? _ratings;

  bool? _ratingStatus;

  Post({
    String? postId,
    String? email,
    String? caption,
    String? imgUri,
    int? numOfLikes,
    int? numOfDislikes,
    int? numOfComments,
    String? category,
    String? ts,
    bool? likedStatus,
    List<Liker>? liker,
    List<Disliker>? disliker,
    List<Commenter>? commenter,
    UserData? users,
    // int? numOfRatings,
    bool? ratingStatus,
    int? ratingValue,
    double? ratings,
  }) {
    if (postId != null) {
      _postId = postId;
    }
    if (likedStatus != null) {
      _likedStatus = likedStatus;
    }
    if (ratingStatus != null) {
      _ratingStatus = ratingStatus;
    }
    if (email != null) {
      _email = email;
    }
    if (caption != null) {
      _caption = caption;
    }
    if (imgUri != null) {
      _imgUri = imgUri;
    }
    if (numOfLikes != null) {
      _numOfLikes = numOfLikes;
    }
    if (numOfDislikes != null) {
      _numOfDislikes = numOfDislikes;
    }
    if (numOfComments != null) {
      _numOfComments = numOfComments;
    }
    /* if (numOfRatings != null) {
      _numOfRatings = numOfRatings;
    } */
    if (category != null) {
      _category = category;
    }
    if (ts != null) {
      _ts = ts;
    }
    if (liker != null) {
      _liker = liker;
    }
    if (disliker != null) {
      _disliker = disliker;
    }
    if (commenter != null) {
      _commenter = commenter;
    }
    if (users != null) {
      _users = users;
    }
    if (ratingValue != null) {
      _ratingValue = ratingValue;
    }
    if (ratings != null) {
      _ratings = ratings;
    }
  }

  int? get ratingValue => _ratingValue;
  set ratingValue(int? value) => _ratingValue = value;
  double? get ratings => _ratings;
  set ratings(double? value) => _ratings = value;
  String? get postId => _postId;
  set postId(String? postId) => _postId = postId;
  bool? get likeStatus => _likedStatus;
  set likeStatus(bool? likedStatus) => _likedStatus = likedStatus;
  bool? get ratingStatus => _ratingStatus;
  set ratingStatus(bool? ratingStatus) => _ratingStatus = ratingStatus;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get caption => _caption;
  set caption(String? caption) => _caption = caption;
  String? get imgUri => _imgUri;
  set imgUri(String? imgUri) => _imgUri = imgUri;
  int? get numOfLikes => _numOfLikes;
  set numOfLikes(int? numOfLikes) => _numOfLikes = numOfLikes;
  int? get numOfDislikes => _numOfDislikes;
  set numOfDislikes(int? numOfDislikes) => _numOfDislikes = numOfDislikes;
  int? get numOfComments => _numOfComments;
  set numOfComments(int? numOfComments) => _numOfComments = numOfComments;
/*   int? get numOfRatings => _numOfRatings;
  set numOfRatings(int? numOfRatings) => _numOfRatings = numOfRatings; */
  String? get category => _category;
  set category(String? category) => _category = category;
  String? get ts => _ts;
  set ts(String? ts) => _ts = ts;
  List<Liker>? get liker => _liker;
  set liker(List<Liker>? liker) => _liker = liker;
  List<Disliker>? get disliker => _disliker;
  set disliker(List<Disliker>? disliker) => _disliker = disliker;
  List<Commenter>? get commenter => _commenter;
  set commenter(List<Commenter>? commenter) => _commenter = commenter;
  UserData? get users => _users;
  set users(UserData? users) => _users = users;

  /*  Post.fromJson(Map<String, dynamic> json) {
    _postId = json['post_id'];
    _email = json['email'];
    _caption = json['caption'];
    _imgUri = json['img_uri'];
    _numOfLikes = json['num_of_likes'];
    _numOfDislikes = json['num_of_dislikes'];
    _category = json['category'];
    _ts = json['ts'];
    _users = json['users'];
    if (json['liker'] != null) {
      _liker = <Liker>[];
      json['liker'].forEach((v) {
        _liker!.add(Liker.fromJson(v));
      });
    }
    if (json['disliker'] != null) {
      _disliker = <Disliker>[];
      json['disliker'].forEach((v) {
        _disliker!.add(Disliker.fromJson(v));
      });
    }
    if (json['commenter'] != null) {
      _commenter = <Commenter>[];
      json['commenter'].forEach((v) {
        _commenter!.add(Commenter.fromJson(v));
      });
    }
  } */

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = _postId;
    data['email'] = _email;
    data['caption'] = _caption;
    data['img_uri'] = _imgUri;
    data['num_of_likes'] = _numOfLikes;
    data['num_of_dislikes'] = _numOfDislikes;
    data['num_of_comments'] = _numOfComments;
    // data['num_of_ratings'] = _numOfRatings;
    data['ratingValue'] = _ratingValue;
    data['ratings'] = _ratings;
    data['category'] = _category;
    data['ts'] = _ts;
    // data['users'] = _users!.toJson();
    if (_liker != null) {
      data['liker'] = _liker!.map((v) => v.toJson()).toList();
    }
    if (_disliker != null) {
      data['disliker'] = _disliker!.map((v) => v.toJson()).toList();
    }
    if (_commenter != null) {
      data['commenter'] = _commenter!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Liker {
  String? _email;

  Liker({String? email}) {
    if (email != null) {
      _email = email;
    }
  }

  String? get email => _email;
  set email(String? email) => _email = email;

  Liker.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    return data;
  }
}

class Disliker {
  String? _email;

  Disliker({String? email}) {
    if (email != null) {
      _email = email;
    }
  }

  String? get email => _email;
  set email(String? email) => _email = email;

  Disliker.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    return data;
  }
}

class Commenter {
  String? _email;
  String? _text;
  String? _ts;
  UserData? _user;

  Commenter({String? email, String? text, String? ts, UserData? user}) {
    if (email != null) {
      _email = email;
    }
    if (text != null) {
      _text = text;
    }
    if (ts != null) {
      _ts = ts;
    }
    if (user != null) {
      _user = user;
    }
  }

  String? get email => _email;
  set email(String? email) => _email = email;
  String? get text => _text;
  set text(String? text) => _text = text;
  String? get ts => _ts;
  set ts(String? ts) => _ts = ts;
  UserData? get user => _user;
  set user(UserData? user) => _user = user;

  Commenter.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
    _text = json['text'];
    _ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email;
    data['text'] = _text;
    data['ts'] = _ts;
    return data;
  }
}
