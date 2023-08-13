import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../utils/custom_text.dart';
import '../utils/my_colors.dart';
import '../utils/my_screensize.dart';

class MyWidget {
  static Future<dynamic> vShowWarnigDialog(
      {required BuildContext context,
      required String message,
      String? buttonText,
      String? desc}) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: message,
        desc: desc ?? "",
        btnOk: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(400, MyScreenSize.mGetHeight(context, 1)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
          child: Text(buttonText ?? "Dismiss"),
        )).show();
  }

  static Widget vLoadMoreButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 2, 58, 69),
          borderRadius: BorderRadius.circular(16)),
      child: /*  isMoreDataLoading
          ? Container(
              child: CircularProgressIndicator(backgroundColor: Colors.white),
            )
          : */
          CustomText(
        text: "Load more",
        fontcolor: Colors.white,
      ),
    );
  }

  static Widget vButtonProgressLoader(
      {double? width, double? height, Color? color, String? labelText}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: width ?? 24,
            height: height ?? 24,
            child: CircularProgressIndicator(
              color: color ?? Colors.white,
              strokeWidth: 2,
            )), // Customize the CircularProgressIndicator as needed
        const SizedBox(
            width:
                8), // Add some spacing between the CircularProgressIndicator and text
        Text(
          labelText ?? 'Loading',
          style: TextStyle(color: color ?? Colors.white),
        ), // Replace with your desired text
      ],
    );
  }

  static Widget vPostShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 48),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }

  static Widget vPostPaginationShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }

  static vCommentShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
          const SizedBox(
            height: 36,
          ),
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
          const SizedBox(
            height: 36,
          ),
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 10),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }

  static vCommentPaginationShimmering({required BuildContext context}) {
    return GFShimmer(
        child: Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: MyScreenSize.mGetHeight(context, 8),
                  width: MyScreenSize.mGetWidth(context, 12),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26)),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MyScreenSize.mGetHeight(context, 3),
                      width: MyScreenSize.mGetWidth(context, 60),
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black26)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MyScreenSize.mGetHeight(context, 2),
                    width: MyScreenSize.mGetWidth(context, 35),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black26),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
              height: MyScreenSize.mGetHeight(context, 6),
              width: MyScreenSize.mGetWidth(context, 80),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black26)),
        ],
      ),
    ));
  }
}

class HeaderCurvedContainerForProfile extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = MyColors.secondColor;
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 50)
      ..relativeLineTo(0, -100)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HeaderCurvedContainerForHome extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = MyColors.secondColor;
    Path path = Path()
      ..relativeLineTo(0, 50)
      ..quadraticBezierTo(
          size.width / 2,
          // bottom-center coltrol
          80,
          size.width,
          // bottom-right
          50)
      ..relativeLineTo(0, -50)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
