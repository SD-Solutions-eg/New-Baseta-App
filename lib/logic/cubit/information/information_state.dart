part of 'information_cubit.dart';

abstract class InformationState extends Equatable {
  const InformationState();

  @override
  List<Object> get props => [];
}

class InformationInitial extends InformationState {}

class FAQsLoading extends InformationState {}

class FAQsGetSuccess extends InformationState {}

class FAQsGetFailed extends InformationState {
  final String error;
  const FAQsGetFailed({
    required this.error,
  });
}

class AboutLoading extends InformationState {}

class AboutGetSuccess extends InformationState {}

class AboutGetFailed extends InformationState {
  final String error;
  const AboutGetFailed({
    required this.error,
  });
}

class ContactUsLoading extends InformationState {}

class ContactUsGetSuccess extends InformationState {}

class ContactUsGetFailed extends InformationState {
  final String error;
  const ContactUsGetFailed({
    required this.error,
  });
}

class ContactFormLoading extends InformationState {}

class ContactFormSendSuccess extends InformationState {}

class ContactFormSendFailed extends InformationState {
  final String error;
  const ContactFormSendFailed({
    required this.error,
  });
}

class CustomTripFormLoading extends InformationState {}

class CustomTripFormSendSuccess extends InformationState {}

class CustomTripFormSendFailed extends InformationState {
  final String error;
  const CustomTripFormSendFailed({
    required this.error,
  });
}

class GetAllChatsLoading extends InformationState {}

class RefreshingChat extends InformationState {}

class GetAllChatsSuccess extends InformationState {}

class GetAllChatsFailed extends InformationState {
  final String error;
  const GetAllChatsFailed({
    required this.error,
  });
}

class GetCompanyReviewsLoading extends InformationState {}

class GetCompanyReviewsSuccess extends InformationState {}

class GetCompanyReviewsFailed extends InformationState {
  final String error;
  const GetCompanyReviewsFailed({
    required this.error,
  });
}

class GetDeliveryReviewsLoading extends InformationState {}

class GetDeliveryReviewsSuccess extends InformationState {}

class GetDeliveryReviewsFailed extends InformationState {
  final String error;
  const GetDeliveryReviewsFailed({
    required this.error,
  });
}

class RatingDeliveryLoading extends InformationState {}

class RatingDeliverySuccess extends InformationState {}

class RatingDeliveryFailed extends InformationState {
  final String error;
  const RatingDeliveryFailed({
    required this.error,
  });
}

class CreateChatLoading extends InformationState {}

class CreateChatSuccess extends InformationState {}

class CreateChatFailed extends InformationState {
  final String error;
  const CreateChatFailed({
    required this.error,
  });
}

class SendMessageLoading extends InformationState {}

class SendMessageSuccess extends InformationState {}

class SendMessageFailed extends InformationState {
  final String error;
  const SendMessageFailed({
    required this.error,
  });
}

class GetMoreMessagesLoading extends InformationState {}

class GetMoreMessagesSuccess extends InformationState {}

class GetMoreMessagesFailed extends InformationState {
  final String error;
  const GetMoreMessagesFailed({
    required this.error,
  });
}
