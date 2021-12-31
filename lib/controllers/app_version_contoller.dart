import 'package:get/get.dart' as getPackage;
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/app_version_response.dart';
import 'package:onehubrestro/repository/app_version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionController {

  AppVersionRepository appVersionRepository = getPackage.Get.put(AppVersionRepository());

  Future<bool> isNewVersion() async {
    try {

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      AppversionResponse appversionResponse = await appVersionRepository.getAppVersion();
      if (appversionResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        VersionData data = appversionResponse.data;
        VersionResult result = data.result;   
        var installedVersion = int.parse(packageInfo.version.replaceAll(RegExp(r'\.'), '0'));
        var minimumVersion = int.parse(result.the1HubRestaurantAndroid);

        if(minimumVersion > installedVersion) {
          return true;
        }
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      return false;
    }
    return false;
  }

}