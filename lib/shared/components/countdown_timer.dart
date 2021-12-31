import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class CountdownTimer extends StatefulWidget {
  CountdownTimer({
    @required this.seconds,
    this.totalSeconds,
    this.size,
  });

  final int seconds;
  final int totalSeconds;
  final double size;

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    log('${widget.seconds}, ${widget.totalSeconds}HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH');
    controller = AnimationController(
      vsync: this,
      duration: Duration(
          seconds: (widget.totalSeconds != null && widget.totalSeconds > 0)
              ? widget.totalSeconds
              : 0),
    );
    controller.reverse(
        from: (widget.totalSeconds != null && widget.totalSeconds > 0)
            ? widget.seconds / widget.totalSeconds
            : 1.0);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size ?? 100,
      height: widget.size ?? 100,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(
            child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) {
            return CustomPaint(
                painter: TimerPainter(
              animation: controller,
              backgroundColor:
                  (controller.value > 0) ? getColor(controller) : Colors.white,
              color: Colors.white,
            ));
          },
        )),
        AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return Text(
                timerString,
                style: AppTextStyle.getPoppinsSemibold()
                    .copyWith(color: getColor(controller), fontSize: 14),
              );
            })
      ]),
    );
  }

  Color getColor(AnimationController animationController) {
    Color color;
    if (animationController.value > 0.6) {
      color = green;
    } else if (animationController.value > 0.3) {
      color = orange;
    } else {
      color = errorRed;
    }

    return color;
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
