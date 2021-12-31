import 'package:dio/dio.dart';
import 'package:onehubrestro/models/status_request.dart';
import 'package:onehubrestro/models/status_response.dart';
import 'package:onehubrestro/repository/dio_initializer.dart';


class RestaurantRepository {
  var _dio = DioInitializer.initializeDio();

  // String domain = 'https://bulbandkey.com/gateway/hubrestro';

  Future<StatusResponse> getRestaurantStatus() async {
    try {
      String url = '/restaurant/status';
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        StatusResponse statusResponse = statusResponseFromJson(response.data);
        return statusResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<StatusResponse> updateRestaurantStatus(StatusRequest request) async {
    try {
      String url = '/restaurant/status';
      Response response = await _dio.post(url, data: request.toJson());
      if (response.statusCode == 200) {
        StatusResponse statusResponse = statusResponseFromJson(response.data);
        return statusResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }


}


