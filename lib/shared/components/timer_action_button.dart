import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/colors.dart';

class TimerActionButton extends StatefulWidget {
  const TimerActionButton(
      {Key key,
      this.secondsRemaining,
      this.onPressed,
      this.label,
      this.showProgressBar,
      this.waitForTimer,
      this.color,
      this.letterSpacing})
      : super(key: key);

  final String label;
  final int secondsRemaining;
  final Function onPressed;
  final bool showProgressBar;
  final bool waitForTimer;
  final Color color;
  final int letterSpacing;

  @override
  _TimerActionButtonState createState() => _TimerActionButtonState();
}

class _TimerActionButtonState extends State<TimerActionButton>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  int _secondsRemaining;
  bool isActive = true;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    // _timer = Timer.
    log('TTTTTTTTTTTTTTTTTTTTTTTT');
    _secondsRemaining =
        (widget.secondsRemaining > 0) ? widget.secondsRemaining : 0;
    Duration oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_secondsRemaining <= 0) {
        setState(() {
          timer.cancel();
          // isActive = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
          // isActive = false;
        });
      }
    });

    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: 0, end: 200).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String minutes = _secondsRemaining ~/ 60 >= 10
        ? '${_secondsRemaining ~/ 60}'
        : '0${_secondsRemaining ~/ 60}';
    String seconds = _secondsRemaining % 60 >= 10
        ? '${_secondsRemaining % 60}'
        : '0${_secondsRemaining % 60}';
    var remainingTime = '($minutes:$seconds)';
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () {
          if (widget.waitForTimer != null && widget.waitForTimer) {
            if (_secondsRemaining == 0) {
              widget.onPressed();
            }
          } else {
            widget.onPressed();
          }
        },
        child: Container(
            height: 60,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: (widget.color ?? kSecondaryColor)
                    .withOpacity((widget.showProgressBar
                        ? 0.7
                        : (isActive)
                            ? 1
                            : 0.5))),
            child: Stack(
              children: <Widget>[
                if (widget.showProgressBar)
                  AnimatedContainer(
                    color: widget.color ?? kSecondaryColor,
                    width: animation.value,
                    duration: Duration(seconds: 2),
                    // curve: Curves.linear,
                  ),
                Center(
                  child: Text(
                      '${widget.label} ${_secondsRemaining > 0 ? remainingTime : ''}',
                      style: AppTextStyle.getPoppinsSemibold().copyWith(
                          color: Colors.white,
                          letterSpacing: widget.letterSpacing ?? 0)),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    controller.dispose();
    super.dispose();
  }
}
