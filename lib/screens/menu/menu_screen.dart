import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/menu/menu-controller.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/models/menu/menu.dart';
import 'package:onehubrestro/models/menu/update_category_request.dart';
import 'package:onehubrestro/screens/home/components/icons.dart';
import 'package:onehubrestro/screens/menu/components/menu_item.dart';
import 'package:onehubrestro/screens/menu/edit/edit_category.dart';
import 'package:onehubrestro/shared/components/app_scaffold.dart';
import 'package:onehubrestro/shared/components/header.dart';
import 'package:onehubrestro/shared/components/searchbar.dart';
import 'package:onehubrestro/screens/menu/components/brand_card.dart';
import 'package:onehubrestro/screens/menu/components/tabbar.dart';
import 'package:onehubrestro/shared/components/snackbar.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';
import 'package:onehubrestro/utilities/transitions/slidetransition.dart';
import 'dart:ui' as prefix0;

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  MenuController menuController;

  int tabIndex = 0;

  _MenuScreenState() {
    NavigationController navigationController =
        Get.find<NavigationController>();
    navigationController.setRoute('/menu');
    menuController = Get.put(MenuController());
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      route: '/menu',
      child: Scaffold(
        appBar: getApplicationAppbar(
          allowBackNavigation: false,
            context: context,
            title: Text('Menu',
                style:
                    AppTextStyle.getPoppinsSemibold().copyWith(fontSize: 18))),
        body: SingleChildScrollView(
          child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Obx(
                () => Column(
                  children: [
                    BrandCard(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SearchBar(
                        onSubmit: (value){
                          menuController.filterSearchedItems(value);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    AppTabBar(
                      onIndexChange: (index) {
                        setState(() {
                          tabIndex = index;
                        });
                      },
                    ),
                    ((!menuController.isLoading.value &&
                                menuController.isLoaded.value) ||
                            menuController.menuPresent.value)
                        ? Column(
                            children: (tabIndex == 0)
                                ? menuController
                                    .getCategoriesToShow()
                                    .map((category) =>
                                        CategoryList(category: category))
                                    .toList()
                                : menuController
                                    .getOutofStockItems()
                                    .map((category) =>
                                        CategoryList(category: category))
                                    .toList())
                        : Center(child: CircularProgressIndicator())
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  CategoryList({this.category});

  final Category category;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  MenuController menuController = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 0.06,
          child: ListTile(
              title: Text(widget.category.name ?? '',
                  style: AppTextStyle.getLatoBold().copyWith(fontSize: 18)),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                onSelected: (value) {
                  switch (value) {
                    case 'edit-category':
                      Navigator.push(
                          context,
                          SlidePageTransition(
                              widget: EditCategoryScreen(
                            category: widget.category,
                          )));
                      break;
                    case 'delete-category':
                      _showConfirmDialog(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('+ Add timings'),
                    value: 'add-time',
                  ),
                  PopupMenuItem(
                    child: Text('Edit category name'),
                    value: 'edit-category',
                  ),
                  if(widget.category.products.length == 0)
                  PopupMenuItem(
                    child: Text('Delete category'),
                    value: 'delete-category',
                  )
                ],
              )),
        ),
        ListTile(
            title: Text((widget.category.name ?? '').toUpperCase(),
                style: AppTextStyle.getLatoMedium()
                    .copyWith(fontSize: 18, letterSpacing: 3)),
            trailing: Switch(
              value: widget.category.isActive,
              onChanged: (status) async {
                Category request = Category(
                    categoryId: widget.category.categoryId, isActive: status);
                if (await menuController.updateCategory(request)) {
                  widget.category.isActive = status;
                  menuController.listCategories();
                } else {
                  String message = menuController.errorMessage.value;

                  AppSnackBar.showErrorSnackBar(
                      message: message, width: size.width);
                }
              },
            )),
        Column(
          children: widget.category.products
              .map((product) => MenuItem(product: product))
              .toList(),
        )
      ],
    );
  }

  void _showConfirmDialog(BuildContext context) async {
    var size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
          },
          child: new BackdropFilter(
              filter: prefix0.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: IntrinsicWidth(
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Do you want to delete the category ?",
                            style: AppTextStyle.getPoppinsSemibold()
                                .copyWith(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Divider(),
                              TextButton(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text('Proceed',
                                          style:
                                              AppTextStyle.getPoppinsSemibold()
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: kSecondaryColor))),
                                  onPressed: () async {
                                    Category request = Category(
                                        categoryId: widget.category.categoryId);
                                    if (await menuController
                                        .updateCategory(request)) {
                                      menuController.listCategories();
                                    } else {
                                      String message =
                                          menuController.errorMessage.value;

                                      AppSnackBar.showErrorSnackBar(
                                          message: message, width: size.width);
                                    }
                                    Navigator.of(context).pop();
                                  }),
                              Divider(),
                              TextButton(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text('Cancel',
                                          style:
                                              AppTextStyle.getPoppinsSemibold()
                                                  .copyWith(
                                                      fontSize: 18,
                                                      color: textGrey))),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
