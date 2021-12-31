import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';


class AppTabBar extends StatelessWidget {

  Function(int) onIndexChange;

  AppTabBar({
    this.onIndexChange
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      height: size.height * 0.08,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                offset: Offset(0, 15),
                blurRadius: 40)
          ]),
      child: TabBar(
        onTap: (index){
          onIndexChange(index);
        },
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: kSecondaryColor),
        unselectedLabelColor: textGrey,
        unselectedLabelStyle:
            AppTextStyle.getLatoSemibold().copyWith(fontSize: 14),
        labelColor: Colors.white,
        labelStyle: 
            AppTextStyle.getLatoSemibold().copyWith(fontSize: 14),
        
        tabs: [Tab(text: 'All Items'), Tab(text: 'Out Of Stock')],
      ),
    );
  }
}
