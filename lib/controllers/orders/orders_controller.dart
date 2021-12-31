import 'dart:async';

import 'package:get/state_manager.dart';
import 'package:get/get.dart' as getPackage;
import 'package:onehubrestro/controllers/outlet/user_controller.dart';
import 'package:onehubrestro/models/api_response.dart';
import 'package:onehubrestro/models/error.dart';
import 'package:onehubrestro/models/order-history/order_history_detail.dart';
import 'package:onehubrestro/models/order-history/order_history_parameters.dart';
import 'package:onehubrestro/models/order-history/order_history_response.dart';
import 'package:onehubrestro/models/order/order_accept_request.dart';
import 'package:onehubrestro/models/order/order_accept_response.dart';
import 'package:onehubrestro/repository/orders.dart';
import 'package:onehubrestro/utilities/dialog_helper.dart';
import 'package:audioplayers/audioplayers.dart';

class OrderController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;

  RxBool isMoreLoading = false.obs;
  RxBool isMoreLoaded = true.obs;

  var errorMessage = ''.obs;

  RxList<OrderItem> pastOrders = <OrderItem>[].obs;

  Rx<DateTime> pastOrdersStartDate = null.obs;

  Rx<DateTime> pastOrdersEndDate = null.obs;

  Rx<OrderDetail> selectedOrder = OrderDetail().obs;

  OrderRepository _orderRepository = Get.put(new OrderRepository());

  UserController userController = Get.find<UserController>();

  Map<int, Timer> timers = Map();

  Map<int, Timer> startTimers = Map();

  updateOrder(OrderDetail order) {
    selectedOrder.value = order;
  }

  Future<bool> acceptOrder({int orderId, int preperationTime}) async {
    try {
      OrderStatusChangeRequest data = OrderStatusChangeRequest(
          orderId: orderId, preparationTime: preperationTime);

      AudioPlayer player = userController.sounds[data.orderId];

      if (player != null) {
        userController.sounds[data.orderId].stop();
        userController.sounds.removeWhere((key, value) => key == data.orderId);
      }

      DialogHelper.showLoader();
      OrderStatusChangeResponse orderStatusChangeResponse =
          await _orderRepository.acceptOrder(data);
      if (orderStatusChangeResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        DialogHelper.hideLoader();
        // if (startTimers[data.orderId] == null) {
        //   startTimers[data.orderId] =
        //       Timer(Duration(minutes: preperationTime), () {
        //     if (timers[data.orderId] == null) {
        //       timers[data.orderId] =
        //           Timer.periodic(Duration(seconds: 10), (timer) {
        //         AudioCache player =
        //             new AudioCache(prefix: 'lib/assets/sounds/');
        //         const alarmAudioPath = "order_beep.mp4";
        //         player.play(alarmAudioPath, isNotification: true);
        //       });
        //     }
        //   });
        // }

        return true;
      } else {
        handleError(orderStatusChangeResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return null;
    }
    return false;
  }

  Future<bool> markOrderReady({int orderId}) async {
    try {
      OrderStatusChangeRequest data =
          OrderStatusChangeRequest(orderId: orderId);

      Timer timer = timers[orderId];

      Timer startTimer = startTimers[orderId];

      if (timer != null) {
        timers[orderId].cancel();
        timers.removeWhere((key, value) => key == orderId);
      }
      if (startTimer != null) {
        startTimers[orderId].cancel();
        startTimers.removeWhere((key, value) => key == orderId);
      }

      DialogHelper.showLoader();
      OrderStatusChangeResponse orderStatusChangeResponse =
          await _orderRepository.markOrderReady(data);
      if (orderStatusChangeResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        DialogHelper.hideLoader();
        return true;
      } else {
        handleError(orderStatusChangeResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return null;
    }
    return false;
  }

  Future<bool> handoverOrder({int orderId}) async {
    try {
      OrderStatusChangeRequest data =
          OrderStatusChangeRequest(orderId: orderId);

      DialogHelper.showLoader();
      OrderStatusChangeResponse orderStatusChangeResponse =
          await _orderRepository.handoverOrder(data);
      if (orderStatusChangeResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        DialogHelper.hideLoader();
        return true;
      } else {
        handleError(orderStatusChangeResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return null;
    }
    return false;
  }

  Future<bool> rejectOrder({int orderId}) async {
    try {
      OrderStatusChangeRequest data =
          OrderStatusChangeRequest(orderId: orderId);

      AudioPlayer player = userController.sounds[data.orderId];

      if (player != null) {
        userController.sounds[data.orderId].stop();
        userController.sounds.removeWhere((key, value) => key == data.orderId);
      }

      DialogHelper.showLoader();
      OrderStatusChangeResponse orderStatusChangeResponse =
          await _orderRepository.rejectOrder(data);
      if (orderStatusChangeResponse.status ==
          APIResponseStatus.success.toString().split('.').last) {
        DialogHelper.hideLoader();
        return true;
      } else {
        handleError(orderStatusChangeResponse.data);
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      DialogHelper.hideLoader();
      return null;
    }
    return false;
  }

  Future<bool> getPastOrders(OrderListParameters parameters) async {
    if (parameters.page == 1) {
      isLoading(true);
      isLoaded(false);
    } else {
      isMoreLoading(true);
      isMoreLoaded(false);
    }

    OrderHistoryListResponse orderHistoryListResponse =
        await _orderRepository.getPastOrders(parameters);
    if (orderHistoryListResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      OrderHistoryListData data = orderHistoryListResponse.data;
      if (data.result.orders != null) {
        if (parameters.page == 1) {
          pastOrders.value = data.result.orders;
        } else {
          pastOrders.addAll(data.result.orders);
        }
        if (parameters.page == 1) {
          isLoading(false);
          isLoaded(true);
        } else {
          isMoreLoading(false);
          isMoreLoaded(true);
        }
        return true;
      }
    } else {
      handleError(orderHistoryListResponse.data);
    }
    if (parameters.page == 1) {
      isLoading(false);
      isLoaded(false);
    } else {
      isMoreLoading(false);
      isMoreLoaded(false);
    }
    ;
    return false;
  }

  Future<bool> getOrderDetail(int orderId) async {
    isLoading(true);
    isLoaded(false);

    OrderHistoryDetailResponse profileResponse =
        await _orderRepository.getPastOrderDetail(orderId);
    if (profileResponse.status ==
        APIResponseStatus.success.toString().split('.').last) {
      OrderHistoryData data = profileResponse.data;
      if (data.result.order != null) {
        updateOrder(data.result.order);
        isLoading(false);
        isLoaded(true);
        return true;
      }
    } else {
      handleError(profileResponse.data);
    }
    isLoading(false);
    isLoaded(false);
    return false;
  }

  void handleError(ErrorData data) {
    DialogHelper.hideLoader();
    errorMessage.value = data.result.error;
  }
}
