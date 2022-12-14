part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {}

class CategoryFailed extends CategoryState {
  final String error;
  const CategoryFailed({
    required this.error,
  });
}

class ChangeLanguageLoading extends CategoryState {}

class ChangeLanguageSuccess extends CategoryState {}

class ChangeLanguageFailed extends CategoryState {
  final String error;
  const ChangeLanguageFailed({
    required this.error,
  });
}

class ChangeFilterLoading extends CategoryState {}

class ChangeFilterSuccess extends CategoryState {}

class SubCategoryLoading extends CategoryState {}

class SubCategorySuccess extends CategoryState {}

class SubCategoryFailed extends CategoryState {
  final String error;
  const SubCategoryFailed({
    required this.error,
  });
}

class WishlistLoading extends CategoryState {}

class WishlistGetSuccess extends CategoryState {}

class WishlistGetFailed extends CategoryState {
  final String error;
  const WishlistGetFailed({
    required this.error,
  });
}

class AddToWishlistLoading extends CategoryState {}

class AddToWishlistSuccess extends CategoryState {}

class AddToWishlistFailed extends CategoryState {
  final String error;
  const AddToWishlistFailed({
    required this.error,
  });
}

class RemoveFromWishlistLoading extends CategoryState {}

class RemoveFromWishlistSuccess extends CategoryState {}

class RemoveFromWishlistFailed extends CategoryState {
  final String error;
  const RemoveFromWishlistFailed({
    required this.error,
  });
}

class SlideshowLoading extends CategoryState {}

class SlideshowSuccess extends CategoryState {}

class SlideshowFailed extends CategoryState {
  final String error;
  const SlideshowFailed({
    required this.error,
  });
}

class BannerLoading extends CategoryState {}

class BannerSuccess extends CategoryState {}

class BannerFailed extends CategoryState {
  final String error;
  const BannerFailed({
    required this.error,
  });
}

class BlogsLoading extends CategoryState {}

class BlogsSuccess extends CategoryState {}

class BlogsFailed extends CategoryState {
  final String error;
  const BlogsFailed({
    required this.error,
  });
}

class AttributesLoading extends CategoryState {}

class AttributesSuccess extends CategoryState {}

class AttributesFailed extends CategoryState {
  final String error;
  const AttributesFailed({
    required this.error,
  });
}

class AttributeTermsLoading extends CategoryState {}

class AttributeTermsSuccess extends CategoryState {}

class AttributeTermsFailed extends CategoryState {
  final String error;
  const AttributeTermsFailed({
    required this.error,
  });
}

class GetSectionsLoading extends CategoryState {}

class GetSectionsSuccess extends CategoryState {}

class GetSectionsFailed extends CategoryState {
  final String error;
  const GetSectionsFailed({
    required this.error,
  });
}

class GetAllCitiesLoading extends CategoryState {}

class GetAllCitiesSuccess extends CategoryState {}

class GetAllCitiesFailed extends CategoryState {
  final String error;
  const GetAllCitiesFailed({
    required this.error,
  });
}

class GetPayTabsAccountLoading extends CategoryState {}

class GetPayTabsAccountSuccess extends CategoryState {}

class GetPayTabsAccountFailed extends CategoryState {
  final String error;
  const GetPayTabsAccountFailed({
    required this.error,
  });
}


class GetAllAreasLoading extends CategoryState {}

class GetAllAreasSuccess extends CategoryState {}

class GetAllAreasFailed extends CategoryState {
  final String error;
  const GetAllAreasFailed({
    required this.error,
  });
}

class GetAllPartnersLoading extends CategoryState {}

class GetAllPartnersSuccess extends CategoryState {}

class GetAllPartnersFailed extends CategoryState {
  final String error;
  const GetAllPartnersFailed({
    required this.error,
  });
}

class GetAppDurationsLoading extends CategoryState {}

class GetAppDurationsSuccess extends CategoryState {}

class GetAppDurationsFailed extends CategoryState {
  final String error;
  const GetAppDurationsFailed({
    required this.error,
  });
}
