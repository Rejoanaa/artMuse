import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:url_launcher/url_launcher.dart';

import '../const/keywords.dart';
import '../models/model.art_guide.dart';
import '../models/model.image_details.dart';
import '../utils/my_date_format.dart';
import '../utils/my_image_utility.dart';

Logger logger = Logger();

class MyServices {
  
  // m: LOCAL OPERATION
  static Future<List<ImageDetailsModel>?> mPickMultipleImageFromLocal() async {
    try {
      ImagePicker imgpicker = ImagePicker();
      final List<XFile> multipleImages = await imgpicker.pickMultiImage();
      List<ImageDetailsModel> imageDetailsModelList = [];
      for (var i = 0; i < multipleImages.length; i++) {
        String imgUrl = multipleImages[i].path;
        // String newImgUrl;
        // c: copy selected
        await MyServices.mCopyImgFileToNewPath(imgFile: File(imgUrl))
            .then((newImgUrl) => {
                  imageDetailsModelList.add(ImageDetailsModel.imageFromLocal(
                      imgUrl: newImgUrl,
                      // e: main code
                      date: MyDateForamt.mFormateDateDB(DateTime.now()),
                      // c: temp: for input img on different date to db
                      /* date: CustomDateForamt.mFormateDateDB(
                          DateTime.now().add(const Duration(days: 2))), */
                      timestamp:
                          DateTime.now().millisecondsSinceEpoch.toString()))
                });
        // final imgFile = File(multipleImages[i].path);
        // String imgStr = Utility.base64String(imgFile.readAsBytesSync());
      }
      return imageDetailsModelList;
    } on PlatformException catch (e) {
      Logger().d('Failed to pick image: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> mPickImgFromLocal() async {
    try {
      final imgXFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imgXFile == null) return null;
      final imgFile = File(imgXFile.path);
      String imgString = MyImageUtility.base64String(imgFile.readAsBytesSync());

      return {
        'imgString': imgString,
        'imgPath': imgXFile.path,
        'imgXFile': imgXFile
      };

      /*  setState(() {
        _imageString = imgString;
      }); */
    } on PlatformException catch (e) {
      Logger().d('Failed to pick image: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> mPickImgCamera() async {
    try {
      final imgXFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (imgXFile == null) return null;

      //! it's memory consuming approach
      /* final imageFileTemp = File(imgXFile.path);
      String imgString = Utility.base64String(imageFileTemp.readAsBytesSync()); */

      // do: get path only
      String imgUrl = imgXFile.path;

      await MyServices.mCopyImgFileToNewPath(imgFile: File(imgUrl))
          .then((value) => imgUrl = value);

      return {MyKeywords.singleImgUrls: imgUrl};
    } on PlatformException catch (e) {
      Logger().d('Failed to pick image: $e');
      return null;
    }
  }

  static Future<String> mCopyImgFileToNewPath({required File imgFile}) async {
    // getting a directory
    final Directory appDocumentDirectory =
        await getApplicationDocumentsDirectory();
    //getting path from directory for saving
    final String appDocumentPath = appDocumentDirectory.path;

    // $email/${Path.basename(imgFile.path)}
    // c: make imgName unique
    final String imgName = Path.basename(imgFile.path);
    // c: copy the imgFile to new path
    final File newImgFile = await imgFile.copy('$appDocumentPath/$imgName');
    // c: convert image file to image path string
    final String newImgUrl = newImgFile.path;
    // c: [Deprecated] it'll consume lots of space in memory
    /* String imgString = Utility.base64String(newImage.readAsBytesSync());
    return imgString; */
    return newImgUrl;
  }

  static mLaunchGmailInbox({required String email}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'https',
      host: 'mail.google.com',
      path: '/mail/u/0/#inbox',
      queryParameters: {'to': email},
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      logger.e('Could not launch Gmail inbox');
    }
  }

  static mExitApp() {
    SystemNavigator.pop();
  }

  static Future<String> mLoadArtGuideJsonData() async {
    String data = "";
    await rootBundle
        .loadString("assets/json_data/art_guide.json")
        .then((value) {
      return data = value;
    }).onError((error, stackTrace) {
      logger.e(stackTrace);
      return data;
    });
    return data;
  }

static  Future<List<ArtGuide>> mParseJsonData() async {
  String jsonData = await mLoadArtGuideJsonData();
  List<dynamic> data = json.decode(jsonData);
  return data.map((item) => ArtGuide.fromJson(item)).toList();
}
}
