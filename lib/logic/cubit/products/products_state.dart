part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsGetSuccess extends ProductsState {}

class ProductsGetFailed extends ProductsState {
  final String error;
  const ProductsGetFailed({
    required this.error,
  });
}

class MoreProductsLoading extends ProductsState {}

class MoreProductsGetSuccess extends ProductsState {}

class MoreProductsGetFailed extends ProductsState {
  final String error;
  const MoreProductsGetFailed({
    required this.error,
  });
}

class CategoryProductsLoading extends ProductsState {}

class CategoryProductsGetSuccess extends ProductsState {}

class CategoryProductsGetFailed extends ProductsState {
  final String error;
  const CategoryProductsGetFailed({
    required this.error,
  });
}

class SaleProductsLoading extends ProductsState {}

class SaleProductsLoadingMore extends ProductsState {}

class SaleProductsGetSuccess extends ProductsState {}

class SaleProductsGetFailed extends ProductsState {
  final String error;
  const SaleProductsGetFailed({
    required this.error,
  });
}

class SearchPartnersLoading extends ProductsState {}

class SearchPartnersGetSuccess extends ProductsState {}

class SearchPartnersGetFailed extends ProductsState {
  final String error;
  const SearchPartnersGetFailed({
    required this.error,
  });
}
