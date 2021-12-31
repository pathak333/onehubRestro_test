import 'package:flutter/material.dart';

Widget getVegIcon() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Icon(
        Icons.crop_square,
        color: Colors.green,
        size: 36,
      ),
      Icon(Icons.circle, color: Colors.green, size: 14),
    ],
  );
}

Widget getNonVegIcon() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Icon(
        Icons.crop_din,
        color: Colors.red,
        size: 36,
      ),
      Icon(Icons.circle, color: Colors.red, size: 14),
    ],
  );
}
