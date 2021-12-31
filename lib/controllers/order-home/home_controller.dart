import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/state_manager.dart';
import 'package:onehubrestro/models/notifications_list.dart';
import 'package:onehubrestro/models/orders.dart';
import 'package:onehubrestro/utilities/secure_storage.dart';

class HomeController extends GetxController {
  var selectedStatus = OrderStatus.preparing.obs;

  RxList<RemoteMessage> notifications = <RemoteMessage>[].obs;

  RxBool restaurantStatus = false.obs;

  SecureStoreMixin secureStoreMixin = SecureStoreMixin();

  @override
  void onInit() {
    secureStoreMixin.getSecureStore("rId", (rId) {
      secureStoreMixin.getSecureStore('n-${rId}', (data) {
        notifications.value = remoteMessageListFromJson(data);
      });
    });
    super.onInit();
  }

  void updateRestaurantStatus(bool status) {
    restaurantStatus.value = status;
  }

  void addNotificationToList(RemoteMessage message) {
    SecureStoreMixin storeMixin = SecureStoreMixin();
    storeMixin.getSecureStore("rId", (rId) {
      storeMixin.getSecureStore("n-${rId}", (data) {
        List<RemoteMessage> notis = remoteMessageListFromJson(data);
        notis.add(message);
        notifications.value = notis;

        storeMixin.setSecureStore(
            "n-${rId}", remoteMessageListToJson(notifications));
      });
    });
  }

  void storeNotificationsList() {
    SecureStoreMixin storeMixin = SecureStoreMixin();
    storeMixin.getSecureStore("rId", (rId) {
      storeMixin.setSecureStore(
          "n-${rId}", remoteMessageListToJson(notifications));
    });
  }
}
