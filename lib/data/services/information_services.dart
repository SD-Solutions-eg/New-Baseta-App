import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:http/http.dart' as http;

const headers = {authorizationTxt: adminBasicAuth};

class InformationServices {
  Future<String> getFAQs() async {
    final language = getApiLanguage();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$faqsEp?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getFAQCategories() async {
    try {
      final language = getApiLanguage();
      final response = await http.get(
        Uri.parse('$baseUrl$faqCategoriesEP?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        log('response.body: ${response.body}');
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAbout() async {
    final language = getApiLanguage();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$aboutEP?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAboutImage() async {
    final language = getApiLanguage();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$aboutImageEP?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getContactUs() async {
    final language = getApiLanguage();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$contactUsEP?$language'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendContactForm(Map<String, dynamic> contactForm) async {
    final language = getApiLanguage();
    try {
      final url =
          '$baseUrl/contact-form-7/v1/contact-forms/85/feedback?$language';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: contactForm,
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAllChats(int id) async {
    final language = getApiLanguage();
    final query =
        '$language&author=$id&$embedTxt=replies&$fieldsTxt=$chatFields';

    final headers = {authorizationTxt: adminBasicAuth};
    try {
      final url = '$baseUrl$chatsEP?$query';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode < 300) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createChat(String chatJson) async {
    final myCredentials = FirebaseAuthBloc.userBasicAuth!;
    log('myCredentials: $FirebaseAuthBloc.userBasicAuth}');
    final headers = {
      authorizationTxt: myCredentials,
      contentTypeTxt: applicationJson,
    };
    try {
      const url = '$baseUrl$chatsEP';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: chatJson,
      );
      if (response.statusCode < 300) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendMessage(String replyJson) async {
    final myCredentials = FirebaseAuthBloc.userBasicAuth!;
    log('myCredentials : $myCredentials');
    final headers = {
      authorizationTxt: myCredentials,
      contentTypeTxt: applicationJson,
    };
    try {
      const url = '$baseUrl$commentEP';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: replyJson,
      );
      if (response.statusCode < 300) {
        return response.body;
      }
      throw json.decode(response.body)['message'] as String;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getCompanyReviews() async {
    final language = getApiLanguage();
    final query =
        '$language&$embedTxt=replies&$fieldsTxt=$companyReviewsFields';

    final headers = {authorizationTxt: adminBasicAuth};
    try {
      final url = '$baseUrl$companyReviewsEP?$query';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode < 300) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getDeliveryReviews(int id) async {
    final language = getApiLanguage();
    final query = '$language&$fieldsTxt=$deliveryReviewsFields&user=$id';

    try {
      final url = '$baseUrl$reviewsEP?$query';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode < 300) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createRating(String ratingJson) async {
    final myCredentials = FirebaseAuthBloc.userBasicAuth!;
    log('myCredentials : $myCredentials');
    try {
      final headers = {
        authorizationTxt: myCredentials,
        contentTypeTxt: applicationJson,
      };
      const url = '$baseUrl$reviewsEP';
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: ratingJson,
      );
      if (response.statusCode < 300) {
        return response.body;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> getMoreMessages(
      {required int chatId,
      required int perPage,
      required int pageNumber}) async {
    try {
      final query =
          'post=$chatId&$perPageTxt=$perPage&$pageTxt=$pageNumber&$fieldsTxt=$commentFields';
      final url = '$baseUrl$commentEP?$query';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode < 300) {
        return response;
      }
      throw response.body;
    } catch (e) {
      rethrow;
    }
  }
}
