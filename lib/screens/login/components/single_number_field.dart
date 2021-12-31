import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/theme.dart';

class OTPField extends StatelessWidget {
  OTPField(
      {Key key,
      this.index,
      this.first,
      this.last,
      this.backgroundcolor,
      this.borderColor,
      List<String> otpDigits,
      bool valid = true})
      : super(key: key) {
    this.otpDigits = otpDigits;
    this.valid = valid;
  }

  final bool first, last;
  bool valid;

  final Color backgroundcolor;
  final Color borderColor;


  final int index;

  List<String> otpDigits;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
        children: [
          Container(
            height: 75,
            width: 55,
            child: TextField(
                onChanged: (value) {
                  if (value.length == 1) {
                    otpDigits.replaceRange(index, index + 1, [value]);
                    if (last == false) {
                      FocusScope.of(context).nextFocus();
                    }
                  }
                  if (value.length == 0) {
                    otpDigits.replaceRange(index, index + 1, [""]);
                    if (first == false) {
                      FocusScope.of(context).previousFocus();
                    }
                  }
                },
                showCursor: false,
                readOnly: false,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundcolor ?? Colors.white,
                  hintText: 'X',
                  hintStyle: placholderStyle.merge(TextStyle(fontSize: 24)),
                  counter: Offstage(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: valid ? borderColor ?? Colors.white: errorRed),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: orange),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
        ]
    );
  }
}
