import 'package:get/state_manager.dart';
import 'package:get/get.dart' as getPackage;
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/menu/menu.dart';

import 'package:onehubrestro/models/menu/menu_list_response.dart';
import 'package:onehubrestro/models/menu/update_category_request.dart';
import 'package:onehubrestro/models/menu/update_category_response.dart';
import 'package:onehubrestro/repository/menu.dart';
import 'package:onehubrestro/utilities/dialog_helper.dart';

class MenuController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool menuPresent = false.obs;

  var errorMessage = ''.obs;
  var searchText = '';
  
  RxList<Category> categories = List<Category>().obs;
  RxList<Category> categoriesToShow = List<Category>().obs;
  RxList<Category> outOfStock = List<Category>().obs;


  MenuRepository restaurantRepository = getPackage.Get.put(MenuRepository());

  @override
  void onInit(){
    listCategories();
    super.onInit();
  }

  List<Category> getCategoriesToShow() {
    return categoriesToShow.value as List<Category>;
  }

  void updateCategoriesToShow(List<Category> value) {
    categoriesToShow.value = value as List<Category>;
  }

  List<Category> getCategories() {
    return categories.value as List<Category>;
  }

  void updateCategories(List<Category> value) {
    categories.value = value as List<Category>;
  }

  List<Category> getOutofStockItems({String text}) {
    if(text == null || text == ''){
      var tempCategories = List<Category>();
      outOfStock.forEach((category){
        if(category.name.toLowerCase().contains(searchText.toLowerCase())){
          tempCategories.add(category);
        }
        else {
          var tempProducts = [...category.products];
          tempProducts.retainWhere((product){
            return product.name.toLowerCase().contains(searchText.toLowerCase());
          });

          if(tempProducts.length > 0){
            var tempCategory = Category.fromJson(category.toJson());
            tempCategory.products = tempProducts;
            tempCategories.add(tempCategory);
          }
        }
      });
      return tempCategories;
    }
    return outOfStock.value as List<Category>;
  }

  void updateOutofStockItems(List<Category> value) {
    outOfStock.value = value as List<Category>;
  }

  Future<bool> listCategories() async {
    isLoading(true);
    isLoaded(false);
    MenuListResponse menuListResponse = await restaurantRepository.listCategories();
    if (menuListResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      MenuListData data = menuListResponse.data;
      if (data.result.categories != null) {
        updateCategories(data.result.categories);
        filterSearchedItems(searchText);
        findOutofStockItems(data.result.categories);
        isLoading(false);
        isLoaded(true);
        menuPresent(true);
        return true;
      }
    } else {
      handleError(menuListResponse.data);
    }
    isLoading(false);
    isLoaded(false);
    return false;
  }

  void findOutofStockItems(List<Category> categories){
    var tempCategories = List<Category>();
    categories.forEach((category){
      var tempProducts = [...category.products];
      tempProducts.retainWhere((product){
        return !product.isInStock;
      });
      if(tempProducts.length > 0){
        var tempCategory = Category.fromJson(category.toJson());
        tempCategory.products = tempProducts;
        tempCategories.add(tempCategory);
      }
    });
    updateOutofStockItems(tempCategories);
  }

  Future<bool> updateCategory(Category data) async {
    DialogHelper.showLoader();
    UpdateCategoryResponse updateCategoryResponse = await restaurantRepository.updateCategory(data);
    if (updateCategoryResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
        listCategories();
        DialogHelper.hideLoader();
        return true;
    } else {
      handleError(updateCategoryResponse.data);
    }
    DialogHelper.hideLoader();
    return false;
  }

  Future<bool> updateProduct(Product data) async {
    DialogHelper.showLoader();
    UpdateCategoryResponse updateCategoryResponse = await restaurantRepository.updateProduct(data);
    if (updateCategoryResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
        listCategories();
        DialogHelper.hideLoader();
        return true;
    } else {
      handleError(updateCategoryResponse.data);
    }
    DialogHelper.hideLoader();
    return false;
  }

  filterSearchedItems(String text){
    if(text == null || text == "") {
      updateCategoriesToShow(getCategories());
    }
    searchText = text;
    var tempCategories = List<Category>();
    categories.forEach((category){
      if(category.name.toLowerCase().contains(searchText.toLowerCase())){
        tempCategories.add(category);
      }
      else {
        var tempProducts = [...category.products];
        tempProducts.retainWhere((product){
          return product.name.toLowerCase().contains(searchText.toLowerCase());
        });

        if(tempProducts.length > 0){
          var tempCategory = Category.fromJson(category.toJson());
          tempCategory.products = tempProducts;
          tempCategories.add(tempCategory);
        }
      }
    });
    updateCategoriesToShow(tempCategories);
  }

  void handleError(ErrorData data) {
    errorMessage.value = data.result.error;
  }

}