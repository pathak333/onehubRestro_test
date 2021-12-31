import 'package:flutter/material.dart';

class DefaulPageTransition extends MaterialPageRoute{
  final Widget widget;

  DefaulPageTransition({this.widget}):super(
    builder: (context) => widget
  );
}