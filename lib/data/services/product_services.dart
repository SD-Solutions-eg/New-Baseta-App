import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  Future<String> getAppText() async {
    final lang = getApiLanguage();
    final headers = {authorizationTxt: adminBasicAuth};

    final url = '$baseUrl$settingsEP?$lang';
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
  }

  Future<http.Response> getProductsList(
      {String? orderBy,
      required String order,
      required int page,
      required int perPage,
      String? filter,
      int? id}) async {
    final List<String> query = [getApiLanguage()];
    if (orderBy != null) {
      query.add('$orderByTxt=$orderBy');
    }
    if (filter != null) {
      query.add(filter);
    } else if (id != null) {
      query.add('package_cat=$id');
    }

    final url = '$baseUrl$packagesEP?${query.join('&')}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response;
    } else {
      log(response.body);
      throw response.body;
    }
  }

  Future<http.Response> getOnSaleProducts({
    required int page,
    required int perPage,
  }) async {
    try {
      final lang = getApiLanguage();
      final List<String> query = [
        '$perPageTxt=$perPage',
        '$pageTxt=$page',
        lang,
      ];
      log(lang);
      final url = '$baseUrl$packagesEP?${query.join('&')}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response;
      } else {
        print(response.reasonPhrase);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> searchPartners({
    required String name,
    required int page,
    required int perPage,
    required String order,
    String? orderBy,
  }) async {
    try {
      final List<String> query = [
        '$perPageTxt=$perPage',
        '$pageTxt=$page',
        '$orderTxt=$order',
        'search=$name',
        '$embedTxt=$featuredMediaEmbedded',
        getApiLanguage(),
      ];
      if (orderBy != null) {
        query.add('$orderByTxt=$orderBy');
      }

      final url = '$baseUrl$partnersEP?${query.join('&')}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response;
      } else {
        print(response.reasonPhrase);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getProduct({required int id}) async {
    final language = getApiLanguage();
    try {
      final url = '$baseUrl$packagesEP$id?$language';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.reasonPhrase);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getMainCategories() async {
    final language = getApiLanguage();
    log(language);
    try {
      final url =
          '$baseUrl/wp/v2/package_cat?$embedTxt=$featuredMediaEmbedded&_fields=id, name,content,acf,_links&$language';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.reasonPhrase);
        throw response.body;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getSlideshow() async {
    final language = getApiLanguage();
    try {
      final query =
          '$language&$fieldsTxt=$slideshowFields&$embedTxt=$featuredMediaEmbedded';
      final headers = {authorizationTxt: adminBasicAuth};
      final response = await http.get(
        Uri.parse('$baseUrl$slideshowEP?$query'),
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

  Future<String> getBlogs() async {
    final language = getApiLanguage();
    try {
      final query =
          '_fields=id, title,content,_links&$embedTxt=$featuredMediaEmbedded&$language';
      final response = await http.get(Uri.parse('$baseUrl$blogsEP?$query'));
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

  Future<String> getAllSections() async {
    final language = getApiLanguage();
    try {
      final query =
          '$fieldsTxt=$sectionsFields&$embedTxt=$featuredMediaEmbedded&$language';
      final headers = {authorizationTxt: adminBasicAuth};
      final response = await http.get(
        Uri.parse('$baseUrl$sectionsEP?$query'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        // log('sections response: ${response.body}');
        return response.body;
      } else {
        log('Get Sections Service Error :${response.reasonPhrase}\n ${response.body}');
        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAllCities() async {
    final language = getApiLanguage();
    try {
      final query = '$fieldsTxt=$citiesFields&$language';
      final headers = {authorizationTxt: adminBasicAuth};
      final response = await http.get(
        Uri.parse('$baseUrl$citiesEp?$query'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        log('Get Cities Service Error :${response.reasonPhrase}\n ${response.body}');
        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAreasByCity(int cityId) async {
    final language = getApiLanguage();
    try {
      final query = '$fieldsTxt=$areasFields&$language&city=$cityId';
      final headers = {authorizationTxt: adminBasicAuth};
      final response = await http.get(
        Uri.parse('$baseUrl$areasEp?$query'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        log('Get Areas Service Error :${response.reasonPhrase}\n ${response.body}');
        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getPartnersBySection(int sectionId) async {
    final language = getApiLanguage();
    try {
      final query =
          '$fieldsTxt=$partnersFields&section=$sectionId&$embedTxt=$featuredMediaEmbedded&$language';
      final headers = {authorizationTxt: adminBasicAuth};
      final response = await http.get(
        Uri.parse('$baseUrl$partnersEP?$query'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        log('Get Partners Service Error :${response.reasonPhrase}\n ${response.body}');
        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getFeaturedPartners() async {
    final language = getApiLanguage();
    try {
      final query =
          '$fieldsTxt=$partnersFields&$featureTxt=1&$embedTxt=$featuredMediaEmbedded&$language';

      final headers = {authorizationTxt: adminBasicAuth};
      print('url is ');
      print('$baseUrl$partnersEP?$query');
      final response = await http.get(
        Uri.parse('$baseUrl$partnersEP?$query'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        log('getFeaturedPartners',error:response.body.toString());
        return response.body;
      } else {
        log('Get Partners Service Error :${response.reasonPhrase}\n ${response.body}');
        throw json.decode(response.body)['message'] as String;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAppDurations() async {
    final headers = {authorizationTxt: adminBasicAuth};

    const url = '$baseUrl$settingsEP';
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
  }

  Future<String> getPayTabsAccount() async {
    try {
      const url = '$baseUrl$payTabsEP';
      final response = await http.get(Uri.parse(url));

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
}
