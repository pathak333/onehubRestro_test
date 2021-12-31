import 'package:flutter/material.dart';
import 'package:onehubrestro/shared/components/drawer.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

AppBar getAppBar(String header, Function onPress) {
  return AppBar(
      title: Text(header, style: AppTextStyle.getPoppinsSemibold().copyWith(
        fontSize: 18
      ),)
    );
}

AppBar getApplicationAppbar({BuildContext context, Widget title, double elevation = 10, bool allowBackNavigation = true}) {
    return AppBar(
      automaticallyImplyLeading: allowBackNavigation,
      elevation: elevation,
      shadowColor: lightGrey,
      title: title,
      actions: [
        IconButton(icon: Icon(Icons.menu, size: 35, color: black), onPressed: () {
          Navigator.push(context, SlidePageTransition(
            widget: AppDrawer()
          ));
        }),
      ],
    );
  }