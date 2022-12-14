import 'package:allin1/data/models/page_header_model.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/product_model.dart';
import 'package:allin1/data/repositories/products_repository.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

const int _defaultPerPageCount = 7;

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository productsRepo;
  final InternetCubit connection;

  ProductsCubit(
    this.productsRepo,
    this.connection,
  ) : super(ProductsInitial());

  static ProductsCubit get(BuildContext context) => BlocProvider.of(context);

  List<ProductModel> products = [];
  List<ProductModel> categoryProducts = [];
  List<ProductModel> onSaleProducts = [];
  List<PartnerModel> searchPartners = [];
  int pages = 1;
  int productsTotal = 1;
  String? orderBy;
  String order = 'desc';
  int pageIndex = 0;
  int perPage = _defaultPerPageCount;
  bool isLoading = false;

  Future<void> getProducts(BuildContext context, int pageNumber,
      {String? filter}) async {
    emit(ProductsLoading());

    if (connection.state is InternetConnectionFail) {
      emit(ProductsGetFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        final responseData = await productsRepo.getProducts(
          order: order,
          orderBy: orderBy,
          page: pageNumber,
          perPage: perPage,
          filter: filter,
        );
        products = responseData['products'] as List<ProductModel>;

        final pagesHeaderModel = responseData['headerModel'] as PageHeaderModel;
        pages = pagesHeaderModel.pages;
        productsTotal = pagesHeaderModel.itemsTotalCount;

        emit(ProductsGetSuccess());
      } catch (e) {
        print('GET Product Error: $e');
        emit(ProductsGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> loadMoreProducts(BuildContext context, int pageNumber,
      {String? filter}) async {
    if (isLoading) {
      return;
    }
    emit(MoreProductsLoading());

    if (connection.state is InternetConnectionFail) {
      emit(MoreProductsGetFailed(
          error: CategoryCubit.appText!.connectionFailed));
    } else {
      isLoading = true;
      try {
        final responseData = await productsRepo.getProducts(
          order: order,
          orderBy: orderBy,
          page: pageNumber,
          perPage: perPage,
          filter: filter,
        );
        final moreProducts = responseData['products'] as List<ProductModel>;

        products.addAll(moreProducts);

        final pagesHeaderModel = responseData['headerModel'] as PageHeaderModel;
        pages = pagesHeaderModel.pages;
        productsTotal = pagesHeaderModel.itemsTotalCount;

        emit(MoreProductsGetSuccess());
      } catch (e) {
        print('GET Product Error: $e');
        emit(MoreProductsGetFailed(error: e.toString()));
      }
      isLoading = false;
    }
  }

  Future<void> getCategoryProducts(
      BuildContext context, int id, int pageNumber) async {
    categoryProducts.clear();
    emit(CategoryProductsLoading());

    if (connection.state is InternetConnectionFail) {
      emit(CategoryProductsGetFailed(
          error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        final responseData = await productsRepo.getCategoryProducts(
          id,
          perPage: perPage,
          order: order,
          orderBy: orderBy,
          page: pageNumber,
        );

        categoryProducts = responseData['products'] as List<ProductModel>;

        final pagesHeaderModel = responseData['headerModel'] as PageHeaderModel;
        pages = pagesHeaderModel.pages;
        productsTotal = pagesHeaderModel.itemsTotalCount;

        emit(CategoryProductsGetSuccess());
      } catch (e) {
        print('GET CategoryProduct Error: $e');
        emit(CategoryProductsGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> loadMoreCategoryProducts(
      BuildContext context, int categoryId, int pageNumber) async {
    if (isLoading) {
      return;
    }
    emit(MoreProductsLoading());

    if (connection.state is InternetConnectionFail) {
      emit(MoreProductsGetFailed(
          error: CategoryCubit.appText!.connectionFailed));
    } else {
      isLoading = true;
      try {
        final responseData = await productsRepo.getCategoryProducts(
          categoryId,
          order: order,
          orderBy: orderBy,
          page: pageNumber,
          perPage: perPage,
        );
        final moreProducts = responseData['products'] as List<ProductModel>;

        categoryProducts.addAll(moreProducts);

        final pagesHeaderModel = responseData['headerModel'] as PageHeaderModel;
        pages = pagesHeaderModel.pages;
        productsTotal = pagesHeaderModel.itemsTotalCount;

        emit(MoreProductsGetSuccess());
      } catch (e) {
        print('GET Product Error: $e');
        emit(MoreProductsGetFailed(error: e.toString()));
      }
      isLoading = false;
    }
  }

  Future<PageHeaderModel?> getOnSaleProducts(
    BuildContext context, {
    int page = 1,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      emit(SaleProductsLoadingMore());
    } else {
      onSaleProducts.clear();
      emit(SaleProductsLoading());
    }

    if (connection.state is InternetConnectionFail) {
      emit(SaleProductsGetFailed(
          error: CategoryCubit.appText!.connectionFailed));
      return null;
    } else {
      try {
        final responseData =
            await productsRepo.getOnSaleProducts(page: page, perPage: 10);
        if (loadMore) {
          onSaleProducts.addAll(responseData['products'] as List<ProductModel>);
        } else {
          onSaleProducts = responseData['products'] as List<ProductModel>;
        }

        emit(SaleProductsGetSuccess());
        return responseData['headerModel'] as PageHeaderModel;
      } catch (e) {
        print('GET Sale Products Error: $e');
        emit(SaleProductsGetFailed(error: e.toString()));
      }
    }
  }

  Future<PageHeaderModel?> searchForPartners(
    BuildContext context, {
    int page = 1,
    int perPage = 10,
    String? orderBy,
    String order = 'desc',
    required String name,
  }) async {
    emit(SearchPartnersLoading());

    if (connection.state is InternetConnectionFail) {
      emit(SearchPartnersGetFailed(
          error: CategoryCubit.appText!.connectionFailed));
      return null;
    } else {
      try {
        final responseData = await productsRepo.searchPartners(
          page: page,
          perPage: perPage,
          name: name,
          order: order,
        );

        searchPartners = responseData['partners'] as List<PartnerModel>;

        emit(SearchPartnersGetSuccess());
        return responseData['headerModel'] as PageHeaderModel;
      } catch (e) {
        print('GET Search Partners Error: $e');
        emit(SearchPartnersGetFailed(error: e.toString()));
      }
    }
  }

  void clearUserData() {
    pages = 1;
    productsTotal = 1;
    orderBy = null;
    order = 'desc';
    // pageNumber = 1;
    pageIndex = 0;
    perPage = _defaultPerPageCount;
  }
}
