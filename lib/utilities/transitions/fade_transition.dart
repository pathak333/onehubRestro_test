import 'package:flutter/material.dart';

class FadePageTransition extends PageRouteBuilder {
  final Widget widget;

  FadePageTransition({this.widget}): super(
    pageBuilder: (context, animation,
            secondaryAnimation) =>
        widget,
    transitionsBuilder: (context,
        animation,
        secondaryAnimation,
        child) {

    animation = CurvedAnimation(
      curve: Curves.easeInOut, parent: animation);
    return FadeTransition(
      opacity:animation,
      child: child,
    );
    });

}