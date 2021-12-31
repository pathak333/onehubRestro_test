import 'package:dio/dio.dart';
import 'package:onehubrestro/utilities/interceptors/interceptors.dart'
    as interceptors;

class DioInitializer {
  static Dio initializeDio() {
    var dio = new Dio(
      new BaseOptions(
        baseUrl: 'https://bulbandkey.com/gateway/hubrestro'
      )
    );

    dio.interceptors.add(interceptors.Headers());

    dio.interceptors.add(interceptors.Logging());

    return dio;
  }
}
