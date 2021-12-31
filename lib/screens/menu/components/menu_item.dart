import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onehubrestro/controllers/image_controller.dart';
import 'package:onehubrestro/controllers/menu/menu-controller.dart';
import 'package:onehubrestro/models/menu/menu.dart';
import 'package:onehubrestro/screens/home/components/icons.dart';
import 'package:onehubrestro/screens/menu/edit/add_timings.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/imageView.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({Key key, @required this.product}) : super(key: key);

  final Product product;

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  MenuController menuController = Get.find<MenuController>();

  ImageController imageController = ImageController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.product.isVeg ? getVegIcon() : getNonVegIcon(),
                Text(widget.product.name,
                    style:
                        AppTextStyle.getLatoSemibold().copyWith(fontSize: 18)),
                SizedBox(height: 5),
                Text(
                  '₹${widget.product.displayPrice}',
                  style:
                      AppTextStyle.getPoppinsSemibold().copyWith(fontSize: 18),
                )
              ],
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                showImageOptions(size);
              },
              child: (widget.product.image == null ||
                      widget.product.image == '')
                  ? Container(
                      height: 100,
                      width: 100,
                      decoration:
                          BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: textGrey),
                          Text("Add Photo",
                              style: AppTextStyle.getLatoMedium()
                                  .copyWith(fontSize: 12, color: textGrey))
                        ],
                      ),
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: ImageView.provideImage(
                                  src: widget.product.image,
                                  type: Sourcetype.network),
                              fit: BoxFit.cover)),
                    ),
            ),
          )
        ]),
      ),
      Divider(
        thickness: 2,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: (widget.product.isRecomended)
                  ? GestureDetector(
                      onTap: () {
                        updateRecommedStatus(false, size);
                      },
                      child: Row(children: [
                        Icon(Icons.thumb_up, color: kSecondaryColor),
                        SizedBox(width: 5),
                        Text(
                          'Recommended',
                          style: AppTextStyle.getLatoSemibold(),
                        ),
                      ]),
                    )
                  : GestureDetector(
                      onTap: () {
                        updateRecommedStatus(true, size);
                      },
                      child: Row(children: [
                        Icon(Icons.thumb_up_outlined),
                        SizedBox(width: 5),
                        Text(
                          'Recommend',
                          style: AppTextStyle.getLatoSemibold(),
                        ),
                      ]),
                    ),
            ),
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: widget.product.isInStock,
                    onChanged: (status) {
                      if (status) {
                        updateStockStatus(true, size);
                      } else {
                        Navigator.push(
                            context,
                            SlidePageTransition(
                                widget:
                                    AddTimingScreen(product: widget.product)));
                      }
                    },
                  ),
                  (widget.product.isInStock)
                      ? Text(
                          'In Stock',
                          style: AppTextStyle.getLatoMedium()
                              .copyWith(color: textGrey),
                        )
                      : Column(
                          children: [
                            Text(
                              'Next Available',
                              style: AppTextStyle.getLatoMedium()
                                  .copyWith(color: textGrey, fontSize: 12),
                            ),
                            Text(
                              widget.product.instockTime,
                              style: AppTextStyle.getLatoMedium()
                                  .copyWith(color: textGrey, fontSize: 12),
                            ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
      Divider(
        thickness: 2,
      ),
    ]));
  }

  void updateRecommedStatus(bool status, var size) async {
    Product request =
        Product(menuId: widget.product.menuId, isRecomended: status);
    if (await menuController.updateProduct(request)) {
    } else {
      String message = menuController.errorMessage.value;

      AppSnackBar.showErrorSnackBar(message: message, width: size.width);
    }
  }

  void updateStockStatus(bool status, var size) async {
    Product request = Product(menuId: widget.product.menuId, isInStock: status);
    if (await menuController.updateProduct(request)) {
    } else {
      String message = menuController.errorMessage.value;

      AppSnackBar.showErrorSnackBar(message: message, width: size.width);
    }
  }

  void showImageOptions(var size) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text('Take Photo'),
                onTap: () {
                  uploadImage('camera', size);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Choose Image'),
                onTap: () {
                  uploadImage('gallery', size);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void uploadImage(String type, var size) async {
    var imageUrl = await imageController.uploadImage(type, size);
    if (imageUrl != null) {
        Product product =
            Product(menuId: widget.product.menuId, image: imageUrl);
        if (await menuController.updateProduct(product)) {
          setState(() {
            widget.product.image = imageUrl;
          });
        } else {
          String message = menuController.errorMessage.value;
          AppSnackBar.showErrorSnackBar(message: message, width: size.width);
        }

        AppSnackBar.showSuccessSnackBar(
            message: 'Image uploaded succesfully', width: size.width);
      } else {
        String message = imageController.errorMessage;
        AppSnackBar.showErrorSnackBar(message: message, width: size.width);
      }
  }
}
