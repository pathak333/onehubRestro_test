import 'package:dio/dio.dart';
import 'package:onehubrestro/models/order-history/order_history_detail.dart';
import 'package:onehubrestro/models/order-history/order_history_parameters.dart';
import 'package:onehubrestro/models/order-history/order_history_response.dart';
import 'package:onehubrestro/models/order/order_accept_request.dart';
import 'package:onehubrestro/models/order/order_accept_response.dart';
import 'package:onehubrestro/repository/dio_initializer.dart';

class OrderRepository {
  var _dio = DioInitializer.initializeDio();

  Future<OrderStatusChangeResponse> acceptOrder(OrderStatusChangeRequest data) async {
      String url = '/order/accept';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        OrderStatusChangeResponse statusResponse = orderStatusChangeResponsefromJson(response.data);
        return statusResponse;
      }
    return null;
  }

  Future<OrderStatusChangeResponse> markOrderReady(OrderStatusChangeRequest data) async {
    try {
      String url = '/order/ready';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        OrderStatusChangeResponse statusResponse = orderStatusChangeResponsefromJson(response.data);
        return statusResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<OrderStatusChangeResponse> handoverOrder(OrderStatusChangeRequest data) async {
    try {
      String url = '/order/handover';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        OrderStatusChangeResponse statusResponse = orderStatusChangeResponsefromJson(response.data);
        return statusResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<OrderStatusChangeResponse> rejectOrder(OrderStatusChangeRequest data) async {
    try {
      String url = '/order/reject';
      Response response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        OrderStatusChangeResponse statusResponse = orderStatusChangeResponsefromJson(response.data);
        return statusResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<OrderHistoryListResponse> getPastOrders(OrderListParameters parameters) async {
    try {
      String url = '/order/list';
      Response response = await _dio.post(url, data: parameters);
      if (response.statusCode == 200) {
        OrderHistoryListResponse settlementResponse = orderHistoryListResponseFromJson(response.data);
        return settlementResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }

  Future<OrderHistoryDetailResponse> getPastOrderDetail(int orderId) async {
    try {
      String url = '/order/view?id=$orderId';
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        OrderHistoryDetailResponse orderHistoryDetailResponse = orderHistoryDetailFromJson(response.data);
        return orderHistoryDetailResponse;
      }
    } catch (error, stacktrace) {
      //TODO can be handle better.
      return null;
    }
    return null;
  }
}