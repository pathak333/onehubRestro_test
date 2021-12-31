import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/orders/orders_realtime_controller.dart';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/restaurant.dart';
import 'package:onehubrestro/models/status_request.dart';
import 'package:onehubrestro/models/status_response.dart';
import 'package:onehubrestro/repository/restaurant.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RestaurantController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;

  Rx<Restaurant> restaurant = Restaurant().obs;

  var errorMessage = ''.obs;

  RestaurantRepository restaurantRepository = Get.put(RestaurantRepository());

  @override
  void onInit() async {
    await getRestaurantStatus();
    super.onInit();
  }

  Restaurant getRestaurant() {
    return restaurant.value;
  }

  void updateRestaurant(Restaurant value) {
    restaurant.value = value;
  }

  Future<bool> getRestaurantStatus() async {

    isLoading(true);
    isLoaded(false);

    StatusResponse statusResponse =
        await restaurantRepository.getRestaurantStatus();
    if (statusResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      StatusData data = statusResponse.data;
      if (data.result.restaurant != null) {
        // SecureStoreMixin storeMixin = new SecureStoreMixin();
        // storeMixin.setSecureStore(
        //     'rId', data.result.restaurant.restaurantId.toString());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

        data.result.restaurant.version = packageInfo.version;
        updateRestaurant(data.result.restaurant);
        isLoading(false);
        isLoaded(true);
        return true;
      }
    } else {
      handleError(statusResponse.data);
    }
    isLoading(false);
    isLoaded(false);
    return false;
  }

  Future<bool> updateRestaurantStatus(bool status) async {
    StatusRequest request = new StatusRequest(
        restaurantId: getRestaurant().restaurantId, status: status);
    StatusResponse statusResponse =
        await restaurantRepository.updateRestaurantStatus(request);
    if (statusResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      StatusData data = statusResponse.data;
      if (data.result.restaurant != null) {
         PackageInfo packageInfo = await PackageInfo.fromPlatform();

        data.result.restaurant.version = packageInfo.version;
        updateRestaurant(data.result.restaurant);
        return true;
      }
    } else {
      handleError(statusResponse.data);
    }

    return true;
  }

  void handleError(ErrorData data) {
    errorMessage.value = data.result.error;
  }
}
