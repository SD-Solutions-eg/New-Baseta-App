import 'dart:developer';

import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/data/models/contact_form_model.dart';
import 'package:allin1/data/models/contact_us_model.dart';
import 'package:allin1/data/models/faq_category_model.dart';
import 'package:allin1/data/models/faq_model.dart';
import 'package:allin1/data/models/page_header_model.dart';
import 'package:allin1/data/models/page_model.dart';
import 'package:allin1/data/models/rating_model.dart';
import 'package:allin1/data/repositories/information_repository.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information_state.dart';

class InformationCubit extends Cubit<InformationState> {
  final InformationRepository informationRepo;
  final InternetCubit connection;
  InformationCubit(
    this.informationRepo,
    this.connection,
  ) : super(InformationInitial());

  static InformationCubit get(BuildContext context) => BlocProvider.of(context);

  List<FAQModel> faqs = [];
  List<FAQCategoryModel> faqCategories = [];
  PageModel? aboutModel;
  ContactUsModel? contactUsModel;
  String? formStatusMsg;
  String? aboutText;
  int chatPages = 2;

  static List<ChatModel> allChats = [];
  static ChatModel? createdChatModel;
  ChatModel? companyReviews;
  List<RatingModel> deliveryReviews = [];

  Future<void> getFAQs() async {
    emit(FAQsLoading());
    if (connection.state is InternetConnectionFail) {
      emit(FAQsGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        faqs = await informationRepo.getFAQs();
        faqCategories = await informationRepo.getFAQCategories();
        emit(FAQsGetSuccess());
      } catch (e) {
        log(e.toString());
        emit(FAQsGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAboutModel() async {
    emit(AboutLoading());
    if (connection.state is InternetConnectionFail) {
      emit(AboutGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        aboutModel = await informationRepo.getAbout();
        emit(AboutGetSuccess());
      } catch (e) {
        emit(AboutGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> getContactUsModel() async {
    emit(ContactUsLoading());
    if (connection.state is InternetConnectionFail) {
      emit(ContactUsGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        contactUsModel = await informationRepo.getContactUs();
        emit(ContactUsGetSuccess());
      } catch (e) {
        emit(ContactUsGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> sendContactForm(ContactFormModel contactFormModel) async {
    emit(ContactFormLoading());
    if (connection.state is InternetConnectionFail) {
      emit(ContactFormSendFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        formStatusMsg = await informationRepo.sendContactForm(contactFormModel);
        emit(ContactFormSendSuccess());
      } catch (e) {
        emit(ContactFormSendFailed(error: e.toString()));
      }
    }
  }

  Future<void> getAllChats({bool refresh = false}) async {
    if (refresh) {
      emit(RefreshingChat());
    } else {
      emit(GetAllChatsLoading());
    }
    if (connection.state is InternetConnectionFail) {
      emit(GetAllChatsFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        if (FirebaseAuthBloc.currentUser != null) {
          allChats = await informationRepo
              .getAllChats(FirebaseAuthBloc.currentUser!.id);
        }
        emit(GetAllChatsSuccess());
      } catch (e) {
        log('Get Chats Failed: $e');
        emit(GetAllChatsFailed(error: e.toString()));
      }
    }
  }

  Future<void> createChat(Map<String, dynamic> chatMap) async {
    emit(CreateChatLoading());
    if (connection.state is InternetConnectionFail) {
      emit(CreateChatFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        createdChatModel = await informationRepo.createChat(chatMap);

        emit(CreateChatSuccess());
      } catch (e) {
        log('Create Chats Failed: $e');
        emit(CreateChatFailed(error: e.toString()));
      }
    }
  }

  Future<void> sendChatMessage(Map<String, dynamic> replyMap) async {
    emit(SendMessageLoading());
    if (connection.state is InternetConnectionFail) {
      emit(SendMessageFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        await informationRepo.sendMessage(replyMap);
        emit(SendMessageSuccess());
      } catch (e) {
        log('Send Chat Message Failed: $e');
        emit(SendMessageFailed(error: e.toString()));
      }
    }
  }

  Future<void> getMoreMessages(
      {required int chatId,
      int perPage = 10,
      int pageNumber = 2,
      bool firstCall = false}) async {
    emit(GetMoreMessagesLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetMoreMessagesFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final responseMap = await informationRepo.getMoreMessages(
          chatId: chatId,
          perPage: perPage,
          pageNumber: pageNumber,
        );
        final newReplies = responseMap['replies'] as List<ReplyModel>;
        final pageHeaderModel = responseMap['pages'] as PageHeaderModel;
        chatPages = pageHeaderModel.pages;

        createdChatModel = createdChatModel!.copyWith(
          replies: [
            if (!firstCall) ...createdChatModel!.replies,
            ...newReplies,
          ],
        );
        emit(GetMoreMessagesSuccess());
      } catch (e) {
        log('GetMoreMessages Failed: $e');
        emit(GetMoreMessagesFailed(error: e.toString()));
      }
    }
  }

  Future<void> getCompanyReviews() async {
    emit(GetCompanyReviewsLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetCompanyReviewsFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        companyReviews = await informationRepo.getCompanyReviews();

        emit(GetCompanyReviewsSuccess());
      } catch (e) {
        log('GetCompanyReviews Failed: $e');
        emit(GetCompanyReviewsFailed(error: e.toString()));
      }
    }
  }

  Future<void> getDeliveryReviews(int deliveryId) async {
    deliveryReviews.clear();
    emit(GetDeliveryReviewsLoading());
    if (connection.state is InternetConnectionFail) {
      emit(GetDeliveryReviewsFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        deliveryReviews = await informationRepo.getDeliveryReviews(deliveryId);

        emit(GetDeliveryReviewsSuccess());
      } catch (e) {
        log('GetDeliveryReviews Failed: $e');
        emit(GetDeliveryReviewsFailed(error: e.toString()));
      }
    }
  }

  Future<void> createRating(Map<String, dynamic> ratingMap,
      {bool isSupervisor = false}) async {
    emit(RatingDeliveryLoading());
    if (connection.state is InternetConnectionFail) {
      emit(RatingDeliveryFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final newRatingModel = await informationRepo.createRating(ratingMap);

        deliveryReviews.insert(0, newRatingModel);

        emit(RatingDeliverySuccess());
      } catch (e) {
        log('Rating Delivery Failed: $e');
        emit(RatingDeliveryFailed(error: e.toString()));
      }
    }
  }

  static void logout() {
    InformationCubit.allChats.clear();
    InformationCubit.createdChatModel = null;
  }
}
