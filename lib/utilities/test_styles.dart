import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';

class AppTextStyle {
  static TextStyle getErrorTextStyle() {
    return TextStyle(
        color: errorRed,
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,);
  }

  static TextStyle getPoppinsRegular() {
    return TextStyle(
        fontFamily: 'Poppins Regular',
        color: black);
  }

  static TextStyle getPoppinsMedium() {
    return TextStyle(
        fontFamily: 'Poppins Medium',
        fontWeight: FontWeight.w500,
        color: black);
  }

  static TextStyle getPoppinsSemibold() {
    return TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: black);
  }

  static TextStyle getPoppinsBold() {
    return TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: black);
  }

  static TextStyle getLatoRegular() {
    return TextStyle(
        fontFamily: 'Lato Regular',
        fontWeight: FontWeight.w400,
        color: black);
  }

  static TextStyle getLatoMedium() {
    return TextStyle(
        fontFamily: 'Lato Medium',
        fontWeight: FontWeight.w500,
        color: black);
  }

  static TextStyle getLatoBold() {
    return TextStyle(
        fontFamily: 'Lato Bold',
        fontWeight: FontWeight.w700,
        color: black);
  }

  static TextStyle getLatoSemibold() {
    return TextStyle(
        fontFamily: 'Lato Semibold',
        fontWeight: FontWeight.w600,
        color: black);
  }
}
