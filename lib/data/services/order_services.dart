import 'dart:convert';
import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:http/http.dart' as http;

class OrdersServices {
  Future<String> getOrders({
    required int customerId,
    required bool isDelivery,
    int perPage = 30,
  }) async {
    try {
      late final String query;
      if (isDelivery) {
        query =
            '$fieldsTxt=$orderFields&$perPageTxt=$perPage&delivery=$customerId&$embedTxt=replies';
      } else {
        query =
            '$fieldsTxt=$orderFields&$perPageTxt=$perPage&author=$customerId&$embedTxt=replies';
      }
      final url = '$baseUrl$ordersEP?$query';
      final headers = {authorizationTxt: adminBasicAuth};

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPaymentGateways() async {
    final language = getApiLanguage();
    try {
      final url = '$baseUrl$paymentEP?$language';
      // final oAuthUrl = getOAuthURL('GET', url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createOrder(String order) async {
    log('auth: ${FirebaseAuthBloc.userBasicAuth}');
    try {
      final headers = {
        contentTypeTxt: applicationJson,
        authorizationTxt: FirebaseAuthBloc.userBasicAuth!,
      };
      const url = '$baseUrl$ordersEP';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: order,
      );

      if (response.statusCode == 201) {
        log(response.body);
        return response.body;
      } else {
        log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getDeliveryLocation(int deliveryId) async {
    try {
      final headers = {authorizationTxt: adminBasicAuth};
      final url =
          '$baseUrl$userDataEP?author=$deliveryId&$fieldsTxt=$userDataFields';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getDeliveryModel(int deliveryId) async {
    try {
      final headers = {authorizationTxt: adminBasicAuth};
      final url = '$baseUrl$usersEP$deliveryId?$fieldsTxt=$userFields';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateDeliveryLocation(
      {required String locationJson, required int userDataId}) async {
    try {
      final headers = {
        contentTypeTxt: applicationJson,
        authorizationTxt: FirebaseAuthBloc.userBasicAuth!,
      };
      final url = '$baseUrl$userDataEP$userDataId?$fieldsTxt=$userDataFields';

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: locationJson,
      );
      if (response.statusCode < 300) {
        return response.body;
      } else {
        log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> changeOrderStatus(
      {required int orderId, required String order}) async {
    try {
      final headers = {
        contentTypeTxt: applicationJson,
        authorizationTxt: FirebaseAuthBloc.userBasicAuth!,
      };
      final url = '$baseUrl$ordersEP/$orderId';
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: order,
      );
      if (response.statusCode < 300) {
        // log(response.body);
        return response.body;
      } else {
        // log(response.body);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> applyCoupon({required String coupon}) async {
    try {
      final headers = {
        contentTypeTxt: applicationJson,
        authorizationTxt: FirebaseAuthBloc.userBasicAuth!,
      };

      const url = '$baseUrl/coupons/v1/validate';
      final body = {"coupon": coupon};

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        log(jsonDecode(response.body).toString());
        return response.body;
      } else {
        throw json.decode(response.body) as String? ?? '';
      }
    } catch (e) {
      rethrow;
    }
  }
}
