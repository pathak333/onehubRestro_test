import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class PhoneNumberFeild extends StatelessWidget {
  final TextEditingController controller;
  final Color backgroundColor;
  final Color borderColor;

  const PhoneNumberFeild(
      {Key key, this.controller, this.backgroundColor, this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a phonenumber';
          }
          if (value.isEmpty || !RegExp(r"^[0-9]{10}$").hasMatch(value)) {
            return 'Enter a valid phonenumber';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: backgroundColor ?? Colors.white,
          filled: true,
          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border:
              OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: borderColor ?? grey),
                borderRadius: BorderRadius.circular(30)),
          focusedBorder:
              OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: borderColor ?? grey),
                borderRadius: BorderRadius.circular(30)),
          prefixIcon: Container(
            width: size.width * 0.15,
            margin: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            child: Text('+91'),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: borderColor ?? grey, width: 2))
            ),
            
          ),
          errorStyle: AppTextStyle.getErrorTextStyle()
        ));
  }
}
