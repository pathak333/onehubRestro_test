import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/menu/menu-controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/models/menu/menu.dart';
import 'package:onehubrestro/models/menu/update_category_request.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class EditCategoryScreen extends StatelessWidget {

  EditCategoryScreen({
    this.category
  }){
  _textController = TextEditingController(text: category.name);
  NavigationController navigationController = Get.find<NavigationController>();
    navigationController.setRoute('/menu');
  }


  final Category category;
  TextEditingController _textController;
  MenuController menuController = Get.find<MenuController>();

  var _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AppContainer(
      route: '/menu',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Edit Category Name',
            style: AppTextStyle.getPoppinsSemibold().copyWith(fontSize: 18),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.04),
                      child: Text('Category Name*',
                          style: AppTextStyle.getPoppinsMedium()
                              .copyWith(fontSize: 18)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.01),
                      child: TextFormField(
                        controller: _textController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter category name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Soups',
                          hintStyle: TextStyle(color: grey),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightGrey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kSecondaryColor)),
                        ),
                      ),
                    ),
                  ],
                )),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Text('Save', style: AppTextStyle.getPoppinsSemibold().copyWith(
                          letterSpacing: 1,
                          color: Colors.white
                        )),
                        style: ElevatedButton.styleFrom(
                          primary: kSecondaryColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          shape: StadiumBorder(),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            Category request = Category(
                              categoryId: category.categoryId,
                              name: _textController.text);
                            if (await menuController
                                          .updateCategory(request)) {
                                        menuController.listCategories();
                                        Navigator.pop(context);
                                      } else {
                                        String message =
                                            menuController.errorMessage.value;

                                        AppSnackBar.showErrorSnackBar(
                                            message: message, width: size.width);
                                      }
                          }
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
