import 'package:flutter/material.dart';

class ImageView {
  // String src;
  // Sourcetype type;

  // ImageView({
  //   @required this.type, 
  //   @required this.src, 
  //   });

    static provideImage({Sourcetype type, String src}) {
    // TODO: implement build
    //AssetBundleImageProvider asset;

      switch(type){
        case Sourcetype.asset:
          return AssetImage(src);
        break;

        case Sourcetype.network:
          return NetworkImage(src);
        break;
      }
    }

    static displayImage({Sourcetype type, String src}) {
    // TODO: implement build
      //AssetBundleImageProvider asset;

      switch(type){
        case Sourcetype.asset:
          return Image.asset(src);
        break;

        case Sourcetype.network:
          return Image.network(src);
        break;
      }
    }

}

enum Sourcetype{
  asset,
  network
}
