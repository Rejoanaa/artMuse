
import '../const/keywords.dart';

class ImageDetailsModel {
  // String? imgUri;
  // late List<String> imgUrlList;

  double? latitude;
  double? longitude;
  String? timestamp;
  String? caption;
  String? email;
  // File? imgFile;
  // Uint8List? strgImgUri;
  bool? imgFromCamera;
  late String imgUrl;
  late String date;


  ImageDetailsModel.imageFromLocal(
      {required this.imgUrl,
      this.caption,
      required this.date,
      required this.timestamp});

  ImageDetailsModel.imageFromCamera(
      {required this.imgUrl,
      this.latitude,
      this.longitude,
      this.timestamp,
      required this.date,
      this.caption,
      this.email});

  ImageDetailsModel.fromJson(Map<String, dynamic> json) {
    // imgUri = json['imgUri'];
    email = json['email'];
    imgUrl = json['imgUrl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    timestamp = json['timestamp'];
    date = json['date'];
    caption = json['caption'];
    imgFromCamera = json['imgFromCamera'];
    // imgFile = json['imgFile'];
  }

  ImageDetailsModel.allDataFromJson(Map<String, dynamic> json) {
    imgUrl = json['imgUrl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    timestamp = json['timestamp'];
    date = json['date'];
    caption = json['caption'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['email'] = email;
    data['imgUrl'] = imgUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['timestamp'] = timestamp;
    data['date'] = date;
    data['caption'] = caption;
    // data['imgFromCamera'] = this.imgFromCamera;
    // data['imgFile'] = this.imgFile;
    return data;
  }

  Map<String, dynamic> allDataToJson() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['imgUrl'] = imgUrl;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['date'] = date;
    map['timestamp'] = timestamp;
    map['caption'] = caption;
    map['email'] = email;

    return map;
  }

  //c: Setter and Getter
/*   get getImgUrlList => imgUrlList;

  set setImgUrlList(imgUrlList) => this.imgUrlList = imgUrlList; */
  get getImgUrl => imgUrl;
  set setImgUrl(imgUrl) => this.imgUrl = imgUrl;
}
