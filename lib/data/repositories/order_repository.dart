// ignore_for_file: avoid_dynamic_calls, join_return_with_assignment

import 'dart:convert';
import 'dart:developer';

import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/order_model.dart';
import 'package:allin1/data/models/payment_model.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/data/services/order_services.dart';
import 'package:intl/intl.dart' as intl;

class OrdersRepository {
  final OrdersServices _ordersServices;
  OrdersRepository(this._ordersServices);

  Future<List<PaymentModel>> getPaymentGateways() async {
    try {
      List<PaymentModel> paymentGateways = [];
      final paymentGatewaysJson = await _ordersServices.getPaymentGateways();
      final paymentGatewaysData =
          json.decode(paymentGatewaysJson) as List<dynamic>;
      paymentGateways = paymentGatewaysData
          .map<PaymentModel>((e) => PaymentModel.fromJson(e))
          .toList();
      return paymentGateways;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrders(
      {required int customerId,
      required bool isDelivery,
      int perPage = 30}) async {
    try {
      final List<OrderModel> orders = [];
      final ordersJson = await _ordersServices.getOrders(
        customerId: customerId,
        isDelivery: isDelivery,
        perPage: perPage,
      );
      final ordersData = json.decode(ordersJson) as List<dynamic>;

      for (final order in ordersData) {
        final orderModel = OrderModel.fromMap(order as Map<String, dynamic>);
        final orderContent =
            intl.Bidi.stripHtmlIfNeeded(orderModel.orderContent);
        final newOrder = orderModel.copyWith(orderContent: orderContent.trim());
        orders.add(newOrder);
      }

      return orders;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> createOrders(Map<String, dynamic> orderMap) async {
    try {
      final createdOrderJson = json.encode(orderMap);
      final returnedOrdersJson =
          await _ordersServices.createOrder(createdOrderJson);
      final returnedOrderData =
          json.decode(returnedOrdersJson) as Map<String, dynamic>;
      log('Created Order: $returnedOrderData');
      final createdOrder = OrderModel.fromMap(returnedOrderData);
      return createdOrder;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDataModel> getDeliveryLocation(int deliveryId) async {
    try {
      final response = await _ordersServices.getDeliveryLocation(deliveryId);
      final list = json.decode(response) as List;
      if (list.isNotEmpty) {
        final deliveryDataModel =
            UserDataModel.fromMap(list.first as Map<String, dynamic>);
        return deliveryDataModel;
      } else {
        return const UserDataModel.create();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getDeliveryModel(int deliveryId) async {
    try {
      final response = await _ordersServices.getDeliveryModel(deliveryId);
      final map = json.decode(response) as Map<String, dynamic>;
      final deliveryModel = UserModel.fromMap(map);
      return deliveryModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDataModel> updateDeliveryLocation(
      {required LocationModel newLocation, required int userDataId}) async {
    try {
      final locationMap = {
        'fields': {
          'main_location': {
            'address': newLocation.address,
            'lat': newLocation.lat,
            'lng': newLocation.lng,
            'zoom': newLocation.zoom,
            'place_id': newLocation.placeId,
            'city': newLocation.city,
            'country': newLocation.country,
            'country_short': newLocation.countryCode,
          }
        }
      };
      final locationJson = json.encode(locationMap);
      final response = await _ordersServices.updateDeliveryLocation(
        locationJson: locationJson,
        userDataId: userDataId,
      );
      final map = json.decode(response) as Map<String, dynamic>;
      final deliveryDataModel = UserDataModel.fromMap(map);
      return deliveryDataModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> updateOrderStatus(
      {required int orderId, required Map<String, dynamic> orderMap}) async {
    try {
      final createdOrderJson = json.encode(orderMap);
      final returnedOrdersJson = await _ordersServices.changeOrderStatus(
          orderId: orderId, order: createdOrderJson);
      final returnedOrderData =
          json.decode(returnedOrdersJson) as Map<String, dynamic>;
      // log('Created Order: $returnedOrderData');
      final createdOrder = OrderModel.fromMap(returnedOrderData);
      return createdOrder;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> applyCoupon({required String coupon}) async {
    try {
      final responseData = await _ordersServices.applyCoupon(coupon: coupon);
      return responseData;
    } catch (e) {
      rethrow;
    }
  }
}
