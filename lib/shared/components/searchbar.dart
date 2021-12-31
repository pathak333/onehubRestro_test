import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class SearchBar extends StatelessWidget {

  final Function(String) onSubmit;

  const SearchBar({
    Key key,
    @required this.onSubmit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 1, color: black)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(width: 1, color: black)
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          prefixIcon: Icon(Icons.search, color: textGrey),
          hintText: 'Search',
          hintStyle: AppTextStyle.getPoppinsRegular()),
          onSubmitted: onSubmit,
    );
  }
}
