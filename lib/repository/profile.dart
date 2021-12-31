import 'package:dio/dio.dart';
import 'package:onehubrestro/models/profile_response.dart';
import 'package:onehubrestro/models/settlements_response.dart';
import 'package:onehubrestro/models/status_request.dart' as prefix0;
import 'package:onehubrestro/models/support_details.dart';
import 'package:onehubrestro/models/update_profile_response.dart';
import 'package:onehubrestro/repository/dio_initializer.dart';


class ProfileRepository {
  var _dio = DioInitializer.initializeDio();

  // String domain = 'https://bulbandkey.com/gateway/hubrestro';

  Future<ProfileResponse> getProfile() async {
    try {
      String url = '/profile/view';
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        ProfileResponse profileResponse = profileResponseFromJson(response.data);
        return profileResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<ProfileResponse> updateProfile(Profile profile) async {
    try {
      String url = '/profile/update';
      Response response = await _dio.post(url, data: profile);
      if (response.statusCode == 200) {
        ProfileResponse profileResponse = profileResponseFromJson(response.data);
        return profileResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<SupportDetailsResponse> getHelpNumbers() async {
    try {
      var dio = new Dio();

      String domain = 'https://bulbandkey.com/gateway/hubrestro';
      String url = domain + '/support/help';
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SupportDetailsResponse supportDetailsResponse = supportDetailsResponsewelcomeFromJson(response.data);
        return supportDetailsResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<SettlementResponse> getSettlementsList() async {
    try {
      String url = '/settlements/list';
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        SettlementResponse settlementResponse = settlementResponseFromJson(response.data);
        return settlementResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

}


