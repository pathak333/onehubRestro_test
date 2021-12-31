import 'package:flutter/material.dart';

class SlidePageTransition extends PageRouteBuilder {
  final Widget widget;

  SlidePageTransition({this.widget}): super(
    pageBuilder: (context, animation,
            secondaryAnimation) =>
        widget,
    transitionsBuilder: (context,
        animation,
        secondaryAnimation,
        child) {

      animation = CurvedAnimation(parent: animation, curve: Curves.linear);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child
      );
    });

}