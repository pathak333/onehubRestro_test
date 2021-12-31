import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/screen_util.dart';

class AppTheme {
    static ThemeData get lightTheme {
      return ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kSecondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: black
        ),
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Poppins', 
            fontSize: 18,
            fontWeight: FontWeight.w600),
          subtitle1: TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.w600), 
          bodyText2: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16),
          )
      );
    } 
}

TextStyle placholderStyle = TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: grey);