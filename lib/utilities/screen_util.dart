/*
 * Created by 李卓原 on 2018/9/29.
 * email: zhuoyuan93@gmail.com
 */

import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenUtil {
  static ScreenUtil instance = new ScreenUtil();

  double width;
  double height;
  bool allowFontScaling;

  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double _bottomBarHeight;

  static double _textScaleFactor;

  ScreenUtil({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,
  });

  static ScreenUtil getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = _mediaQueryData.devicePixelRatio;
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _statusBarHeight = _mediaQueryData.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _textScaleFactor = _mediaQueryData.textScaleFactor;
    _safeAreaHorizontal = _mediaQueryData.padding.left +  _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +  _mediaQueryData.padding.bottom;
//    print("window "+window.physicalSize.toString());
//    print("window "+window.padding.toString());
//    print("window "+window.toString());
//    print("_screenHeight "+_screenHeight.toString());
//    print("viewInsets "+_mediaQueryData.viewInsets.bottom.toString());
//    print("viewInsets "+_mediaQueryData.viewInsets.top.toString());
//     print("_safeAreaHorizontal "+_safeAreaHorizontal.toString());
//     print("_safeAreaVertical"+_safeAreaVertical.toString());
//    print("_textScaleFactor"+_textScaleFactor.toString());
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;


  static double get textScaleFactory => _textScaleFactor;


  static double get pixelRatio => _pixelRatio;

  static double get screenWidthDp => _screenWidth;


  static double get screenHeightDp => _screenHeight;


  static double get screenWidth => _screenWidth * _pixelRatio;


  static double get screenHeight => _screenHeight * _pixelRatio;

  static double get statusBarHeight => _statusBarHeight * _pixelRatio;


  static double get bottomBarHeight => _bottomBarHeight * _pixelRatio;


  get scaleWidth => (_screenWidth+_safeAreaHorizontal) / instance.width;

  get scaleHeight => (_screenHeight+_safeAreaVertical) / (instance.height);



  setWidth(int width) => width * scaleWidth;


  setHeight(int height) => height * scaleHeight;

  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is true.
  setSp(int fontSize) => allowFontScaling
      ? setWidth(fontSize)
      : setWidth(fontSize) / _textScaleFactor;
}
