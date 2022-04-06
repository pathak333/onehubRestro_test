import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class Countdown extends StatefulWidget {
  const Countdown({Key key, this.secondsRemaining, this.totalSecond})
      : super(key: key);
  final int secondsRemaining;
  final int totalSecond;
  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer _timer;
  int _secondsRemaining;
  bool isActive = true;
  @override
  void initState() {
    _secondsRemaining =
        (widget.secondsRemaining > 0) ? widget.secondsRemaining : 0;
    Duration oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_secondsRemaining <= 0) {
        if (mounted) {
          setState(() {
            timer.cancel();
            // isActive = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
            // isActive = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = _secondsRemaining ~/ 60 >= 10
        ? '${_secondsRemaining ~/ 60}'
        : '0${_secondsRemaining ~/ 60}';
    String seconds = _secondsRemaining % 60 >= 10
        ? '${_secondsRemaining % 60}'
        : '0${_secondsRemaining % 60}';
    var remainingTime = '$minutes:$seconds';

    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        width: 70,
        height: 100,
        //padding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1.8,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: getColor(_secondsRemaining),
                value: _secondsRemaining / widget.totalSecond,
                strokeWidth: 4,
              ),
            ),
            Center(
              child: Text(
                '$remainingTime',
                style: AppTextStyle.getPoppinsSemibold()
                    .copyWith(color: getColor(_secondsRemaining), fontSize: 14),
              ),
            )
          ],
        ));
  }

  Color getColor(int seconds) {
    Color color;
    if (seconds > widget.totalSecond * 0.6) {
      color = green;
    } else if (seconds > widget.totalSecond * 0.3) {
      color = orange;
    } else {
      color = errorRed;
    }

    return color;
  }
}
