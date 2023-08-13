

import 'package:flutter/material.dart';

import '../../../utils/my_colors.dart';
import '../../../utils/my_screensize.dart';

class HomeBottomNavBar extends StatefulWidget {
  const HomeBottomNavBar({
    super.key,
    required this.fabLocation,
    this.shape,
    required this.callback,
    required this.pageIndex,
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Function callback;
  final int pageIndex;

  static final centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
  ];

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  Color tabColor0 = MyColors.fifthColor;
  Color tabColor1 = MyColors.fifthColor;

  @override
  void initState() {
    print("Nav call");
    switch (widget.pageIndex) {
      case 0:
        tabColor0 = MyColors.thirdColor;
        break;
      case 1:
        tabColor1 = MyColors.thirdColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final localizations = GalleryLocalizations.of(context)!;
    return BottomAppBar(
      color: MyColors.secondColor,
      shape: widget.shape,
      elevation: 5,
      height: MyScreenSize.mGetHeight(context, 10),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                widget.callback(0);
                setState(() {
                  tabColor1 = tabColor0;
                  tabColor0 = MyColors.thirdColor;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: tabColor0,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(color: tabColor0),
                  )
                ],
              ),
            ),

            /* InkWell(
              onTap: () {
                widget.callback(1);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ), */

            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.white),
              ),
            ),
            //  const SizedBox(width: 1,)

            // if (centerLocations.contains(fabLocation)) const Spacer(),
            /* InkWell(
              onTap: () {
                widget.callback(2);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "chat",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ), */

            InkWell(
              onTap: () {
                setState(() {
                  tabColor0 = tabColor1;
                  tabColor1 = MyColors.thirdColor;
                });
                widget.callback(1);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: tabColor1,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(color: tabColor1),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
