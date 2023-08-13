
import 'package:flutter/material.dart';

import '../../../utils/my_colors.dart';
import '../../../utils/my_screensize.dart';

class RatingDialog extends StatefulWidget {
  final Function callback;
  final int ratingValue;
  const RatingDialog(
      {super.key, required this.callback, required this.ratingValue});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int _currentRate;
  @override
  void initState() {
    super.initState();
    _currentRate = widget.ratingValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Do you want to rate this?",
              style: TextStyle(color: MyColors.secondColor, fontSize: 18),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 1;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 1 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 2;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 2 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 3;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 3 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 4;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 4 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentRate = 5;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color:
                        _currentRate < 5 ? Colors.black26 : MyColors.thirdColor,
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                widget.callback(_currentRate);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MyScreenSize.mGetWidth(context, 40),
                      MyScreenSize.mGetHeight(context, 2))),
              child: const Text(
                "Ok",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
