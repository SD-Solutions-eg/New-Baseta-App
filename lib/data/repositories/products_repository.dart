import 'dart:convert';
import 'dart:developer';

import 'package:allin1/data/models/page_header_model.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/product_model.dart';
import 'package:allin1/data/services/product_services.dart';

class ProductsRepository {
  final ProductServices _apiServices;
  ProductsRepository(this._apiServices);

  Future<Map<String, dynamic>> getProducts({
    String? orderBy,
    required String order,
    required int page,
    required int perPage,
    String? filter,
  }) async {
    final products = <ProductModel>[];

    try {
      final response = await _apiServices.getProductsList(
        order: order,
        orderBy: orderBy,
        page: page,
        perPage: perPage,
        filter: filter,
      );

      final productsData = json.decode(response.body) as List<dynamic>;

      for (final productData in productsData) {
        final productModel =
            ProductModel.fromMap(productData as Map<String, dynamic>);

        products.add(productModel);
      }

      final pageHeaderModel = PageHeaderModel.fromMap(response.headers);
      return {
        'products': products,
        'headerModel': pageHeaderModel,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCategoryProducts(
    int id, {
    int page = 1,
    String? orderBy,
    String order = 'desc',
    required int perPage,
  }) async {
    final categoryProducts = <ProductModel>[];

    try {
      final response = await _apiServices.getProductsList(
        order: order,
        orderBy: orderBy,
        page: page,
        id: id,
        perPage: perPage,
      );

      final productsData = json.decode(response.body) as List<dynamic>;

      for (final productData in productsData) {
        final productModel =
            ProductModel.fromMap(productData as Map<String, dynamic>);

        categoryProducts.insert(0, productModel);
      }

      final pageHeaderModel = PageHeaderModel.fromMap(response.headers);

      return {
        'products': categoryProducts,
        'headerModel': pageHeaderModel,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOnSaleProducts(
      {required int page, required int perPage}) async {
    final onSaleProducts = <ProductModel>[];

    try {
      final response =
          await _apiServices.getOnSaleProducts(page: page, perPage: perPage);

      final productsData = json.decode(response.body) as List<dynamic>;

      for (final productData in productsData) {
        final productModel =
            ProductModel.fromMap(productData as Map<String, dynamic>);

        onSaleProducts.insert(0, productModel);
      }

      final pageHeaderModel = PageHeaderModel.fromMap(response.headers);
      return {
        'products': onSaleProducts,
        'headerModel': pageHeaderModel,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProduct(int id) async {
    try {
      final unFormattedJson = await _apiServices.getProduct(id: id);
      final productData = json.decode(unFormattedJson) as Map<String, dynamic>;

      final productModel = ProductModel.fromMap(productData);

      return productModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> searchPartners({
    required int page,
    required int perPage,
    required String name,
    required String order,
    String? orderBy,
  }) async {
    try {
      final searchPartners = <PartnerModel>[];
      final response = await _apiServices.searchPartners(
        name: name,
        page: page,
        perPage: perPage,
        order: order,
        orderBy: orderBy,
      );
      final partnersData = json.decode(response.body) as List<dynamic>;

      for (final map in partnersData) {
        final partnerMode = PartnerModel.fromMap(map as Map<String, dynamic>);
        log('Partner: $partnerMode');

        searchPartners.add(partnerMode);
      }

      final pageHeaderModel = PageHeaderModel.fromMap(response.headers);
      return {
        'partners': searchPartners,
        'headerModel': pageHeaderModel,
      };
    } catch (e) {
      rethrow;
    }
  }
}
