import 'package:dio/dio.dart';
import 'package:onehubrestro/models/menu/menu.dart';
import 'package:onehubrestro/models/menu/menu_list_response.dart';
import 'package:onehubrestro/models/menu/update_category_request.dart';
import 'package:onehubrestro/models/menu/update_category_response.dart';
import 'package:onehubrestro/repository/dio_initializer.dart';

class MenuRepository {
  var _dio = DioInitializer.initializeDio();

  String domain = 'https://bulbandkey.com/gateway/hubrestro';

  Future<MenuListResponse> listCategories() async {
      String url = '/category/list';
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        MenuListResponse statusResponse = menuListResponseFromJson(response.data);
        return statusResponse;
      }
    return null;
  }

  Future<UpdateCategoryResponse> updateCategory(Category data) async {
      String url = '/category/update';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        UpdateCategoryResponse statusResponse = updateCategoryResponseFromJson(response.data);
        return statusResponse;
      }
    return null;
  }

  Future<UpdateCategoryResponse> deleteCategory(Category data) async {
      String url = '/category/delete';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        UpdateCategoryResponse statusResponse = updateCategoryResponseFromJson(response.data);
        return statusResponse;
      }
    return null;
  }

  Future<UpdateCategoryResponse> updateProduct(Product data) async {
      String url = '/menuitem/update';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        UpdateCategoryResponse statusResponse = updateCategoryResponseFromJson(response.data);
        return statusResponse;
      }
    return null;
  }

}