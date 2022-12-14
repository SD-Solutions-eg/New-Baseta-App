import 'dart:async';
import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:http/http.dart' as http;

class NotificationsServices {
  Future<String> getNotifications({
    required int userId,
  }) async {
    try {
      // final headers = {
      //   authorizationTxt: 'Bearer $token',
      //   contentTypeTxt: applicationJson,
      // };
      final response =
          await http.get(Uri.parse('$baseUrl$notificationsEP?user_id=$userId'));

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
}
