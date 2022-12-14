import 'dart:developer';

import 'package:allin1/data/models/app_duration_model.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/city_model.dart';
import 'package:allin1/data/models/partner_model.dart';
import 'package:allin1/data/models/paytabs_model.dart';
import 'package:allin1/data/models/product_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/data/models/slideshow_model.dart';
import 'package:allin1/data/models/text_model.dart';
import 'package:allin1/data/repositories/category_repository.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepo;
  final InternetCubit connection;
  CategoryCubit(
    this.categoryRepo,
    this.connection,
  ) : super(CategoryInitial());

  static CategoryCubit get(BuildContext context) => BlocProvider.of(context);

  List<SlideshowModel> slideshowList = [];
  Map<String, int> selectedFilters = {};
  static AppText? appText;
  static String? currency;
  static AppDurationModel appDurations = const AppDurationModel.init();
  static PayTabsModel payTabsModel = PayTabsModel();

  List<SectionModel> allSections = [];
  List<CityModel> allCities = [];
  List<AreaModel> allAreas = [];
  List<PartnerModel> allPartners = [];
  List<PartnerModel> featuredPartners = [];

  Future<void> getAppText(BuildContext context) async {
    emit(ChangeLanguageLoading());

    if (connection.state is InternetConnectionFail) {
      print(' getAppText Error: Connection failed');
    } else {
      try {
        appText = await categoryRepo.getAppText();
        emit(ChangeLanguageSuccess());
      } catch (e) {
        print(' getAppText Error: $e');
        emit(ChangeLanguageFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAppCurrency(BuildContext context) async {
    emit(ChangeLanguageLoading());

    if (connection.state is InternetConnectionFail) {
      print(' getAppText Error: Connection failed');
    } else {
      try {
        currency = 'USD';
        log('Currency is: $currency');
        emit(ChangeLanguageSuccess());
      } catch (e) {
        print(' getAppCurrency Error: $e');
        emit(ChangeLanguageFailed(error: e.toString()));
      }
    }
  }

  void addNewFilter(String key, int value) {
    emit(ChangeFilterLoading());
    selectedFilters[key] = value;
    emit(ChangeFilterSuccess());
  }

  void clearFilter() {
    emit(ChangeFilterLoading());
    selectedFilters.clear();
    emit(ChangeFilterSuccess());
  }

  Future<ProductModel?> getProduct(BuildContext context, int id) async {
    if (connection.state is InternetConnectionFail) {
      emit(WishlistGetFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        return categoryRepo.getProduct(id);
      } catch (e) {
        print('GET Wishlist Product Error: $e');
        emit(WishlistGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> getSlideshow(BuildContext context) async {
    emit(SlideshowLoading());
    if (connection.state is InternetConnectionFail) {
      emit(SlideshowFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        slideshowList = await categoryRepo.getSlideshow();
        emit(SlideshowSuccess());
      } catch (e) {
        print(' Slideshow Error: $e');
        emit(SlideshowFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAllSections() async {
    emit(GetSectionsLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetSectionsFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        allSections = await categoryRepo.getAllSections();
        emit(GetSectionsSuccess());
      } catch (e) {
        log(' GetSections Error: $e');
        emit(GetSectionsFailed(error: e.toString()));
      }
    }
  }

  Future<void> getPayTabsAccount() async {
    emit(GetPayTabsAccountLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetPayTabsAccountFailed(
          error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        payTabsModel = await categoryRepo.getPayTabsAccount();

        emit(GetPayTabsAccountSuccess());
      } catch (e) {
        log('GetPayTabsAccount Error: $e');
        emit(GetPayTabsAccountFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAllCities() async {
    allCities.clear();
    emit(GetAllCitiesLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetAllCitiesFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        allCities = await categoryRepo.getAllCities();
        log('All Cities: $allCities');
        emit(GetAllCitiesSuccess());
      } catch (e) {
        log(' GetAllCities Error: $e');
        emit(GetAllCitiesFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAreasByCity(int cityId) async {
    emit(GetAllAreasLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetAllAreasFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        allAreas = await categoryRepo.getAreasByCity(cityId);
        log('Areas of (City: $cityId) are: $allAreas');

        emit(GetAllAreasSuccess());
      } catch (e) {
        log(' GetAllAreas Error: $e');
        emit(GetAllAreasFailed(error: e.toString()));
      }
    }
  }

  Future<void> getPartnersBySection(int sectionId) async {
    emit(GetAllPartnersLoading());
    if (connection.state is InternetConnectionFail) {
      emit(
          GetAllPartnersFailed(error: CategoryCubit.appText!.connectionFailed));
    } else {
      try {
        if (sectionId != 0) {
          allPartners = await categoryRepo.getPartnersBySection(sectionId);
        } else {
          featuredPartners = await categoryRepo.getFeaturedPartners();
        }
        log('Partners of (Section: $sectionId) are: $allPartners');

        emit(GetAllPartnersSuccess());
      } catch (e) {
        log(' GetAllPartners Error: $e');
        emit(GetAllPartnersFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAppDurations() async {
    emit(GetAppDurationsLoading());
    if (connection.state is InternetConnectionFail) {
      print(' GetAppDurations Error: Connection failed');
    } else {
      try {
        appDurations = await categoryRepo.getAppDurations();

        emit(GetAppDurationsSuccess());
      } catch (e) {
        log(' GetAppDurations Error: $e');
        emit(GetAppDurationsFailed(error: e.toString()));
      }
    }
  }
}
