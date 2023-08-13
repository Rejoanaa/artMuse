class ArtGuide {
  String? _title;
  String? _videoUrl;

  ArtGuide({String? title, String? videoUrl}) {
    if (title != null) {
      _title = title;
    }
    if (videoUrl != null) {
      _videoUrl = videoUrl;
    }
  }

  String? get title => _title;
  set title(String? title) => _title = title;
  String? get videoUrl => _videoUrl;
  set videoUrl(String? videoUrl) => _videoUrl = videoUrl;

  ArtGuide.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = _title;
    data['video_url'] = _videoUrl;
    return data;
  }
}
