// ignore_for_file: require_trailing_commas, avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/data/models/app_duration_model.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/blog_model.dart';
import 'package:allin1/data/models/category_model.dart';
import 'package:allin1/data/models/city_model.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/paytabs_model.dart';
import 'package:allin1/data/models/product_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/data/models/slideshow_model.dart';
import 'package:allin1/data/models/text_model.dart';
import 'package:allin1/data/services/product_services.dart';
import 'package:intl/intl.dart' as intl;

class CategoryRepository {
  final ProductServices _apiServices;
  CategoryRepository(this._apiServices);

  Future<AppText> getAppText() async {
    try {
      final textJson = await _apiServices.getAppText();
      final appTextData = (json.decode(textJson) as Map<String, dynamic>)['acf']
          as Map<String, dynamic>;
      final appTextModel = AppText.fromMap(appTextData);
      return appTextModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final categories = <CategoryModel>[];

    try {
      final categoriesJson = await _apiServices.getMainCategories();
      final categoriesData = json.decode(categoriesJson);
      for (final categoryData in categoriesData) {
        final categoryModel =
            CategoryModel.fromMap(categoryData as Map<String, dynamic>);

        categories.add(categoryModel);
      }
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getMainCategories() async {
    final categories = <CategoryModel>[];

    try {
      final categoriesJson = await _apiServices.getMainCategories();
      final categoriesData = json.decode(categoriesJson);
      for (final categoryData in categoriesData) {
        final categoryModel =
            CategoryModel.fromMap(categoryData as Map<String, dynamic>);

        categories.add(categoryModel);
      }
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getSubCategories(int parentId) async {
    final categories = <CategoryModel>[];

    try {
      final categoriesJson = await _apiServices.getMainCategories();
      final categoriesData = json.decode(categoriesJson);
      for (final categoryData in categoriesData) {
        final categoryModel =
            CategoryModel.fromMap(categoryData as Map<String, dynamic>);

        categories.add(categoryModel);
      }
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProduct(int id) async {
    try {
      final unFormattedJson = await _apiServices.getProduct(id: id);

      final productData = json.decode(unFormattedJson) as Map<String, dynamic>;
      final description =
          intl.Bidi.stripHtmlIfNeeded(productData['description'] as String);
      final shortDescription = intl.Bidi.stripHtmlIfNeeded(
          productData['short_description'] as String);
      final productModel = ProductModel.fromMap(productData);
      final newProduct = productModel.copyWith(
          description: description, shortDescription: shortDescription);

      return newProduct;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SlideshowModel>> getSlideshow() async {
    final slideshowList = <SlideshowModel>[];

    try {
      final unformattedJson = await _apiServices.getSlideshow();
      final slideshowData = json.decode(unformattedJson) as List<dynamic>;
      for (final slideshow in slideshowData) {
        const bool showInMobile = true;

        final subtitle = intl.Bidi.stripHtmlIfNeeded(
            slideshow['content']['rendered'] as String? ?? '');
        if (showInMobile) {
          final slideshowModel =
              SlideshowModel.fromMap(slideshow as Map<String, dynamic>);
          final newSlideshow = slideshowModel.copyWith(subtitle: subtitle);
          slideshowList.add(newSlideshow);
        }
      }
      return slideshowList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogModel>> getBlogs() async {
    final List<BlogModel> blogs = [];

    try {
      final unformattedJson = await _apiServices.getBlogs();
      final blogsData = json.decode(unformattedJson);
      for (final blog in blogsData) {
        final blogModel = BlogModel.fromMap(blog as Map<String, dynamic>);
        final title = intl.Bidi.stripHtmlIfNeeded(
            blog['title'][renderedTxt] as String? ?? '');
        final content = intl.Bidi.stripHtmlIfNeeded(
            blog['content'][renderedTxt] as String? ?? '');
        final newBlogModel = blogModel.copyWith(
          title: title,
          content: content,
        );

        blogs.add(newBlogModel);
      }
      return blogs;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SectionModel>> getAllSections() async {
    final List<SectionModel> listOfModels = [];

    try {
      final unformattedJson = await _apiServices.getAllSections();
      final data = json.decode(unformattedJson);
      for (final map in data) {
        final model = SectionModel.fromMap(map as Map<String, dynamic>);
        final title = intl.Bidi.stripHtmlIfNeeded(model.title);
        final content = intl.Bidi.stripHtmlIfNeeded(model.content);
        final newSectionModel = model.copyWith(
          title: title,
          content: content,
        );

        listOfModels.add(newSectionModel);
      }
      return listOfModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CityModel>> getAllCities() async {
    final List<CityModel> listOfModels = [];

    try {
      final unformattedJson = await _apiServices.getAllCities();
      final data = json.decode(unformattedJson);
      for (final map in data) {
        final model = CityModel.fromMap(map as Map<String, dynamic>);
        final title = intl.Bidi.stripHtmlIfNeeded(model.name);
        final newModel = model.copyWith(name: title);

        listOfModels.add(newModel);
      }
      return listOfModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AreaModel>> getAreasByCity(int cityId) async {
    final List<AreaModel> listOfModels = [];

    try {
      final unformattedJson = await _apiServices.getAreasByCity(cityId);
      final data = json.decode(unformattedJson);
      for (final map in data) {
        final model = AreaModel.fromMap(map as Map<String, dynamic>);
        final title = intl.Bidi.stripHtmlIfNeeded(model.name);
        final newModel = model.copyWith(name: title);
        print(' ${model.name} cost: ${model.deliveryPrice}');
        listOfModels.add(newModel);
      }
      return listOfModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PartnerModel>> getPartnersBySection(int sectionId) async {
    final List<PartnerModel> listOfModels = [];

    try {
      final unformattedJson =
          await _apiServices.getPartnersBySection(sectionId);
      final data = json.decode(unformattedJson);
      for (final map in data) {
        final model = PartnerModel.fromMap(map as Map<String, dynamic>);

        listOfModels.add(model);
      }
      return listOfModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PartnerModel>> getFeaturedPartners() async {
    final List<PartnerModel> listOfModels = [];

    try {
      final unformattedJson = await _apiServices.getFeaturedPartners();
      final data = json.decode(unformattedJson);
      for (final map in data) {
        final model = PartnerModel.fromMap(map as Map<String, dynamic>);

        listOfModels.add(model);
      }
      return listOfModels;
    } catch (e) {
      rethrow;
    }
  }

  Future<AppDurationModel> getAppDurations() async {
    try {
      final unformattedJson = await _apiServices.getAppDurations();
      final data = json.decode(unformattedJson);
      final durationModel =
          AppDurationModel.fromMap(data['acf'] as Map<String, dynamic>);
      return durationModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<PayTabsModel> getPayTabsAccount() async {
    try {
      final response = await _apiServices.getPayTabsAccount();
      final data = json.decode(response) as Map?;
      log('Data: $data');
      if (data != null && data.isNotEmpty && data['paytabs_account'] is Map) {
        final paytabsMap = data['paytabs_account'] as Map<String, dynamic>;
        final model = PayTabsModel.fromMap(paytabsMap);
        return model;
      }
      return PayTabsModel();
    } catch (e) {
      rethrow;
    }
  }
}
