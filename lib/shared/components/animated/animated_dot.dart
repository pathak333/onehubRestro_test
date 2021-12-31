import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';


class AnimatedDot extends StatefulWidget {

  const AnimatedDot({
    Key key,
    this.color,
    this.size
  }) : super(key: key);

  final Color color;
  final double size;

  @override
  _AnimatedDotState createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot> with SingleTickerProviderStateMixin{

  Animation<double> animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        new AnimationController(vsync: this,
        lowerBound: 0.5,
         duration: Duration(milliseconds: 2000))..repeat();
    animation = new CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
      ScaleTransition(
          scale: animation,
          child: new Container(
                decoration: new BoxDecoration(
                    color: (widget.color ?? Colors.white).withOpacity(0.3), shape: BoxShape.circle),
                height: widget.size ?? 30.0,
                width: widget.size ?? 30.0,
              )
        ),
        Icon(
          Icons.circle,
          size: widget.size != null ? ((widget.size > 10) ? widget.size - 10.0 : 0) : 20.0,
          color: widget.color ?? Colors.white,
        )
      ],
    );
  }
}