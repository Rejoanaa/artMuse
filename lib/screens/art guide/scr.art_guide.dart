
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/my_services.dart';
import 'package:flutter_application_1/screens/art%20guide/page/video_player_page.dart';
import 'package:flutter_application_1/utils/my_colors.dart';
import 'package:flutter_application_1/widgets/my_widget.dart';
import 'package:getwidget/getwidget.dart';

import '../../models/model.art_guide.dart';

class ArtGuideScreen extends StatefulWidget {
  const ArtGuideScreen({super.key});

  @override
  State<ArtGuideScreen> createState() => _ArtGuideScreenState();
}

class _ArtGuideScreenState extends State<ArtGuideScreen> {
  List<ArtGuide>? _listArtGuides;

  @override
  void initState() {
    super.initState();
    logger.v("init: Art Guide Screen");

    mLoadData();
  }

  @override
  Widget build(BuildContext context) {
    logger.v("Build: Art Guide Screen");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: MyColors.secondColor),
        elevation: 1,
        title: const Text(
          "Art Guide",
          style: TextStyle(color: MyColors.secondColor),
        ),
      ),
      body: vHome(),
    );
  }

  vHome() {
    return _listArtGuides == null
        ? MyWidget.vCommentPaginationShimmering(context: context)
        : ListView.builder(
            itemCount: _listArtGuides!.length,
            itemBuilder: (BuildContext context, int index) {
              final artGuide = _listArtGuides![index];
              return GFListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                          videoUrl: artGuide.videoUrl!, title: artGuide.title!),
                    ),
                  );
                },
                color: Colors.white,
                icon: const GFAvatar(
                  backgroundColor: Colors.red,
                  shape: GFAvatarShape.standard,
                  child: Icon(Icons.play_arrow, color: Colors.white,),
                ),
                titleText: artGuide.title,
              );
              /*  ListTile(
          title: Text('Video $index'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(videoUrl: artGuide.videoUrl!, title: artGuide.title!),
              ),
            );
          },
        ); */
            },
          );
  }

  void mLoadData() async {
    MyServices.mParseJsonData().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _listArtGuides = value;
        });
      }
    });
  }
}
