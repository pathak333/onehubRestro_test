import 'package:dio/dio.dart';
import 'package:onehubrestro/models/app_version_response.dart';

class AppVersionRepository {

  var _dio = new Dio();

  String url = 'https://bulbandkey.com/gateway/sakal/mobile/creator/getcurrentappversion';

  Future<AppversionResponse> getAppVersion() async {
    Response response = await _dio.get(url);
    if(response.statusCode == 200){
      AppversionResponse appversionResponse = appversionFromJson(response.data);
      return appversionResponse;
    }
    return null;
  }

  
}