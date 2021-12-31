import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class NoOrderComponent extends StatelessWidget {
  const NoOrderComponent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('No Orders Yet',style: AppTextStyle.getPoppinsSemibold().copyWith(
            fontSize: 28
          ),),
          SizedBox(height: 15),
          Center(child: SvgPicture.asset('lib/assets/images/no_orders.svg'))
        ],
      ),
    );
  }
}
