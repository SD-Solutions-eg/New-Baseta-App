import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/http_exception.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AuthenticationServices {
  Future<Map<String, dynamic>> registration({
    required String email,
    required String username,
    required String uid,
  }) async {
    // final language = getApiLanguage();
    try {
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      final body = {'username': username, 'email': email, 'password': uid};

      const url = '$baseUrl/wp/v2/users';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createUserData(
      String myCredentials, String username) async {
    try {
      final headers = {
        authorizationTxt: myCredentials,
        contentTypeTxt: applicationJson,
      };
      final body = {
        "status": "publish",
        "title": username,
        "fields": {
          "mobile": "",
          "address": "",
          "main_location": null,
          "locations": [],
          "area": null,
        }
      };

      const url = '$baseUrl/wp/v2/user_data';

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteAccount({
    required String myCredentials,
  }) async {
    try {
      final headers = {authorizationTxt: myCredentials};
      final response = await http.delete(
        Uri.parse('$baseUrl$loginEP?force=true&reassign=1'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        throw json.decode(response.body)['message'] as String? ??
            json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String passwordOrUid,
  }) async {
    try {
      final myCredentials =
          'Basic ${base64Encode(utf8.encode('$email:$passwordOrUid'))}';
      log('My Credentials are: $myCredentials');
      final headers = {authorizationTxt: myCredentials};

      // final language = getApiLanguage();

      final response = await http.post(
        Uri.parse('$baseUrl$loginEP'),
        headers: headers,
      );

      if (response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> setDeviceFCMToken(int id, String token) async {
    final query = 'user_id=$id&device_token=$token';
    final url = '$baseUrl$setTokenEP?$query';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = response.body;

        return responseData;
      } else {
        log(json.decode(response.body).toString());
        final error = Bidi.stripHtmlIfNeeded((json.decode(response.body)
            as Map<String, dynamic>)['message'] as String);
        throw HttpException(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserModel({required int id}) async {
    final language = getApiLanguage();
    try {
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      final url = '$baseUrl$usersEP$id?$language';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserDataModel({required int id}) async {
    try {
      print('getUserDataModel');
      final query = 'author=$id&$fieldsTxt=$userDataFields';
      final headers = {authorizationTxt: adminBasicAuth};
      final url = '$baseUrl$userDataEP?$query';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        return body.isNotEmpty ? body.first as Map<String, dynamic> : {};
      } else {
        log(json.decode(response.body).toString());

        throw json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> searchForUserByMobileNumber(
      {required String mobileNumber}) async {
    final headers = {authorizationTxt: adminBasicAuth};
    final query = '$fieldsTxt:id,name&search=$mobileNumber';
    try {
      final url = '$baseUrl$usersEP?$query';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode < 300) {
        return response.body;
      } else {
        log(json.decode(response.body).toString());
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserData({
    required int id,
    required String customerJson,
  }) async {
    final language = getApiLanguage();
    try {
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      final url = '$baseUrl$usersEP$id?$language';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: customerJson,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(String newPasswordJson, int id) async {
    try {
      final language = getApiLanguage();
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      final url = '$baseUrl$usersEP$id?$language';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: newPasswordJson,
      );
      if (response.statusCode != 200) {
        log(json.decode(response.body).toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserByEmail({required String email}) async {
    try {
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      print("email is : $email");
      final url = '$baseUrl$usersEP?search=$email';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print('get user byMail');
        print(response.body);
        final Map<String, dynamic> customerData =
            (json.decode(response.body) as List<dynamic>).isNotEmpty
                ? (json.decode(response.body) as List<dynamic>)[0]
                    as Map<String, dynamic>
                : {};
        return customerData;
      } else {
        log(json.decode(response.body).toString());

        throw json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    final language = getApiLanguage();
    try {
      final response = await http
          .post(Uri.parse('$baseUrl$resetPasswordEP?email=$email&$language'));
      if (response.statusCode == 200) {
        final responseData = response.body;

        return responseData;
      } else {
        log(json.decode(response.body).toString());
        final error = (json.decode(response.body)
            as Map<String, dynamic>)['message'] as String;
        throw HttpException(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> validateAndChangePassword(
      String email, String code, String newPassword) async {
    final language = getApiLanguage();
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl$validateAndSetPasswordEP?$language&email=$email&password=$newPassword&code=$code',
        ),
      );
      if (response.statusCode == 200) {
        final responseData = response.body;

        return responseData;
      } else {
        log(json.decode(response.body).toString());
        final error = (json.decode(response.body)
            as Map<String, dynamic>)['message'] as String;
        throw HttpException(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPolicyByEP({required String policyEP}) async {
    try {
      final language = getApiLanguage();
      final headers = {authorizationTxt: adminBasicAuth};
      final response = await http.get(
        Uri.parse('$baseUrl$policyEP?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final policyData = response.body;

        return policyData;
      } else {
        log(json.decode(response.body).toString());

        return response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPolicyImageByEP({required String policyImageEP}) async {
    try {
      final language = getApiLanguage();
      final headers = {authorizationTxt: adminBasicAuth};

      final response = await http.get(
        Uri.parse('$baseUrl$policyImageEP?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final policyData = response.body;

        return policyData;
      } else {
        log(json.decode(response.body).toString());

        return response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserMobile({
    required int dataId,
    required String dataJson,
  }) async {
    try {
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      final url = '$baseUrl$userDataEP$dataId?$fieldsTxt=$userDataFields';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: dataJson,
      );

      if (response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateMyLocations({
    required int dataId,
    required String locationsJson,
  }) async {
    try {
      final headers = {
        authorizationTxt: adminBasicAuth,
        contentTypeTxt: applicationJson,
      };
      final url = '$baseUrl$userDataEP$dataId?$fieldsTxt=$userDataFields';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: locationsJson,
      );

      if (response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());

        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(
      {required String fileName, required Uint8List imageBytes}) async {
    try {
      final headers = {
        'Content-Type': 'image/jpeg',
        'Content-Disposition': 'attachment; filename=$fileName',
        authorizationTxt: adminBasicAuth,
      };

      const url = '$baseUrl/wp/v2/media';

      final request = http.Request('POST', Uri.parse(url));

      request.headers.addAll(headers);
      request.bodyBytes = imageBytes;

      final response = await request.send();

      final body = await response.stream.bytesToString();
      if (response.statusCode < 300) {
        // log('Uploading image Success: $body');
        return body;
      } else {
        log('Error Uploading image: $body');
        throw body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserAvatar({
    required int id,
    required int avatarId,
    // required String token,
  }) async {
    final language = getApiLanguage();
    final query = '$language&$fieldsTxt=$userFields';

    try {
      final headers = {
        authorizationTxt: FirebaseAuthBloc.userBasicAuth!,
        contentTypeTxt: 'application/json',
      };

      final body = {
        "simple_local_avatar": {"media_id": avatarId}
      };

      final url = '$baseUrl$usersEP$id?$query';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode < 300) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        log(json.decode(response.body).toString());
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadVoiceMessage(
      {required String fileName, required Uint8List audioBytes}) async {
    try {
      final headers = {
        'Content-Type': 'audio/mpeg',
        'Content-Disposition': 'attachment; filename=$fileName',
        authorizationTxt: adminBasicAuth,
      };

      const url = '$baseUrl/wp/v2/media';

      final request = http.Request('POST', Uri.parse(url));

      request.headers.addAll(headers);
      request.bodyBytes = audioBytes;

      final response = await request.send();

      final body = await response.stream.bytesToString();
      if (response.statusCode < 300) {
        log('Uploading image Success: $body');
        return body;
      } else {
        log('Error Uploading image: $body');
        throw body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendSmsOtp({required String phoneNumber}) async {
    try {
      print("sendSmsOtp");
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Accept-Language": "en-US"
      };
      const url = 'https://smssmartegypt.com/sms/api/otp-send';
      final Map data = {
        "username": "basita",
        "password": "8D55F4*oS", //basita123456
        "sender": 'Basita',
        "mobile": phoneNumber,
        "lang": apiLanguageCode,
      };
      final body = jsonEncode(data);
      log('phoneNumber: $phoneNumber');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      print(body);
      print(response.body);
      if (response.statusCode == 200) {
        log(json.decode(response.body).toString());
        return response.body;
      } else {
        log('${response.reasonPhrase}\n ${response.body}');
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> checkSmsOtp(
      {required String phoneNumber, required String otp}) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Accept-Language": "en-US"
      };
      const url = 'https://smssmartegypt.com/sms/api/otp-check';
      final Map data = {
        "username": "basita",
        "password": "8D55F4*oS",
        "mobile": phoneNumber,
        "otp": otp,
        "verify": true
      };
      final body = jsonEncode(data);
      print('otp Body is::');
      print(body.toString());
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        log(json.decode(response.body).toString());
        return response.body;
      } else {
        throw json.decode(response.body).toString();
      }
    } catch (e) {
      rethrow;
    }
  }
}
