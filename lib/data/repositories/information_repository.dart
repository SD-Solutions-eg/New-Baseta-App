import 'dart:convert';

import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/data/models/contact_form_model.dart';
import 'package:allin1/data/models/contact_us_model.dart';
import 'package:allin1/data/models/faq_category_model.dart';
import 'package:allin1/data/models/faq_model.dart';
import 'package:allin1/data/models/page_header_model.dart';
import 'package:allin1/data/models/page_model.dart';
import 'package:allin1/data/models/rating_model.dart';
import 'package:allin1/data/services/information_services.dart';
import 'package:intl/intl.dart' as intl;

class InformationRepository {
  final InformationServices _infoServices;

  InformationRepository(this._infoServices);

  Future<List<FAQModel>> getFAQs() async {
    try {
      final faqs = <FAQModel>[];
      final faqsUnformattedJson = await _infoServices.getFAQs();
      final faqsJson = intl.Bidi.stripHtmlIfNeeded(faqsUnformattedJson);
      final faqsData = json.decode(faqsJson) as List<dynamic>;
      for (final faqData in faqsData) {
        final faqModel = FAQModel.fromMap(faqData as Map<String, dynamic>);
        faqs.add(faqModel);
      }
      return faqs;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FAQCategoryModel>> getFAQCategories() async {
    try {
      final faqCategories = <FAQCategoryModel>[];
      final faqsUnformattedJson = await _infoServices.getFAQCategories();
      final faqCategoriesJson =
          intl.Bidi.stripHtmlIfNeeded(faqsUnformattedJson);
      final faqCategoriesData = json.decode(faqCategoriesJson) as List<dynamic>;
      for (final faqCategoryData in faqCategoriesData) {
        final faqCategoryModel =
            FAQCategoryModel.fromMap(faqCategoryData as Map<String, dynamic>);
        faqCategories.add(faqCategoryModel);
      }
      return faqCategories;
    } catch (e) {
      rethrow;
    }
  }

  // Future<AboutModel> getAbout() async {
  //   try {
  //     final aboutUnformattedJson = await _infoServices.getAbout();
  //     final aboutJson = intl.Bidi.stripHtmlIfNeeded(aboutUnformattedJson);
  //     final aboutData = json.decode(aboutJson) as Map<String, dynamic>;

  //     final aboutModel = AboutModel.fromMap(aboutData);

  //     return aboutModel;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<PageModel> getAbout() async {
    try {
      final aboutUnformattedJson = await _infoServices.getAbout();
      final aboutJson = intl.Bidi.stripHtmlIfNeeded(aboutUnformattedJson);
      final about = json.decode(aboutJson) as Map<String, dynamic>;
      final content = about['about'] as String;
      final aboutImageJson = await _infoServices.getAboutImage();
      final aboutImage = json.decode(aboutImageJson) as Map<String, dynamic>;
      final image = PageImageModel.fromMap(
        aboutImage['about_image'] as Map<String, dynamic>,
      );
      final aboutModel = PageModel(content: content, image: image);

      return aboutModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ContactUsModel> getContactUs() async {
    try {
      final contactUsUnformattedJson = await _infoServices.getContactUs();
      final contactUsJson =
          intl.Bidi.stripHtmlIfNeeded(contactUsUnformattedJson);
      final contactUsData = json.decode(contactUsJson) as Map<String, dynamic>;

      final contactUsModel = ContactUsModel.fromMap(contactUsData);

      return contactUsModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> sendContactForm(ContactFormModel contactForm) async {
    try {
      final contactFormData = contactForm.toMap();
      final responseJson = await _infoServices.sendContactForm(contactFormData);
      final response = json.decode(responseJson) as Map<String, dynamic>;
      final message = response['message'] as String?;
      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatModel>> getAllChats(int id) async {
    try {
      final responseJson = await _infoServices.getAllChats(id);
      final response = json.decode(responseJson) as List;
      final List<ChatModel> allChats = [];
      for (final chatData in response) {
        final chatModel = ChatModel.fromMap(chatData as Map<String, dynamic>);
        allChats.add(chatModel);
      }
      return allChats;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> createChat(Map<String, dynamic> chatMap) async {
    try {
      final responseJson = await _infoServices.createChat(json.encode(chatMap));
      final response = json.decode(responseJson) as Map<String, dynamic>;

      final chatModel = ChatModel.fromMap(response);

      return chatModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ReplyModel> sendMessage(Map<String, dynamic> replyMap) async {
    try {
      final responseJson =
          await _infoServices.sendMessage(json.encode(replyMap));
      final response = json.decode(responseJson) as Map<String, dynamic>;

      final replyModel = ReplyModel.fromMap(response);

      return replyModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> getCompanyReviews() async {
    try {
      final responseJson = await _infoServices.getCompanyReviews();
      final response = json.decode(responseJson) as Map<String, dynamic>;
      final companyReviewModel = ChatModel.fromMap(response);

      return companyReviewModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RatingModel>> getDeliveryReviews(int id) async {
    try {
      final responseJson = await _infoServices.getDeliveryReviews(id);
      final response = json.decode(responseJson) as List;
      final List<RatingModel> deliveryReviews = [];
      for (final review in response) {
        final ratingModel = RatingModel.fromMap(review as Map<String, dynamic>);
        deliveryReviews.add(ratingModel);
      }
      return deliveryReviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<RatingModel> createRating(Map<String, dynamic> ratingMap) async {
    try {
      final ratingJson = json.encode(ratingMap);
      final responseJson = await _infoServices.createRating(ratingJson);
      final response = json.decode(responseJson) as Map<String, dynamic>;

      final ratingModel = RatingModel.fromMap(response);

      return ratingModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMoreMessages(
      {required int chatId,
      required int perPage,
      required int pageNumber}) async {
    try {
      final response = await _infoServices.getMoreMessages(
        chatId: chatId,
        perPage: perPage,
        pageNumber: pageNumber,
      );
      final messagesData = json.decode(response.body) as List;
      final List<ReplyModel> messages = [];
      for (final map in messagesData) {
        final replyModel = ReplyModel.fromMap(map as Map<String, dynamic>);
        messages.add(replyModel);
      }
      final pagesModel = PageHeaderModel.fromMap(response.headers);

      return {
        'replies': messages,
        'pages': pagesModel,
      };
    } catch (e) {
      rethrow;
    }
  }
}
