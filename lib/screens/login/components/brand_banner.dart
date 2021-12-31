import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onehubrestro/utilities/imageView.dart';

class BrandBanner extends StatelessWidget {
  const BrandBanner({
    Key key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.6,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageView.provideImage(
                        type: Sourcetype.asset,
                        src: 'lib/assets/images/Login-page-image.png'),
                    fit: BoxFit.fill)),
          ),
          Positioned(
            bottom: 100,
            child: SvgPicture.asset('lib/assets/icons/logo.svg'),
          ),
          Positioned(
            bottom: 100,
            child: Text('1Hub Restaurant',
                style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(fontSize: 24, color: Colors.white))),
          )
        ],
      ),
    );
  }
}