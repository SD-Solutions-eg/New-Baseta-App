part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerGetLoading extends CustomerState {}

class CustomerGetSuccess extends CustomerState {}

class CustomerGetFailed extends CustomerState {
  final String error;
  const CustomerGetFailed({required this.error});
}

class CustomerUpdateLoading extends CustomerState {}

class CustomerUpdateSuccess extends CustomerState {}

class CustomerUpdateFailed extends CustomerState {
  final String error;
  const CustomerUpdateFailed({required this.error});
}

class UpdatePasswordLoading extends CustomerState {}

class UpdatePasswordSuccess extends CustomerState {}

class UpdatePasswordFailed extends CustomerState {
  final String error;
  const UpdatePasswordFailed({required this.error});
}

class SendSmsLoading extends CustomerState {}

class SendSmsSuccess extends CustomerState {}

class SendSmsFailed extends CustomerState {
  final String error;
  const SendSmsFailed({required this.error});
}

class CheckOtpLoading extends CustomerState {}

class CheckOtpSuccess extends CustomerState {}

class CheckOtpFailed extends CustomerState {
  final String error;
  const CheckOtpFailed({required this.error});
}

class VerifyPhoneLoading extends CustomerState {}

class VerifyPhoneSent extends CustomerState {}

class VerifyOTPLoading extends CustomerState {}

class VerifyOTPSuccess extends CustomerState {}

class VerifyPhoneFailed extends CustomerState {
  final String error;
  const VerifyPhoneFailed({required this.error});
}

class ReverifyPhoneLoading extends CustomerState {}

class ReverifyPhoneSent extends CustomerState {}

class ReverifyOTPLoading extends CustomerState {}

class ReverifyOTPSuccess extends CustomerState {}

class ReverifyPhoneFailed extends CustomerState {
  final String error;
  const ReverifyPhoneFailed({required this.error});
}

class PrivacyGetLoading extends CustomerState {}

class PrivacyGetSuccess extends CustomerState {}

class PrivacyGetFailed extends CustomerState {
  final String error;
  const PrivacyGetFailed({required this.error});
}

class TermsGetLoading extends CustomerState {}

class TermsGetSuccess extends CustomerState {}

class TermsGetFailed extends CustomerState {
  final String error;
  const TermsGetFailed({required this.error});
}

class ShippingPolicyGetLoading extends CustomerState {}

class ShippingPolicyGetSuccess extends CustomerState {}

class ShippingPolicyGetFailed extends CustomerState {
  final String error;
  const ShippingPolicyGetFailed({required this.error});
}

class ReturnPolicyGetLoading extends CustomerState {}

class ReturnPolicyGetSuccess extends CustomerState {}

class ReturnPolicyGetFailed extends CustomerState {
  final String error;
  const ReturnPolicyGetFailed({required this.error});
}

class ResetPasswordLoading extends CustomerState {}

class ResetPasswordSuccess extends CustomerState {
  final String message;
  const ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailed extends CustomerState {
  final String error;
  const ResetPasswordFailed({required this.error});
}

class ValidateAndChangePasswordLoading extends CustomerState {}

class ValidateAndChangePasswordSuccess extends CustomerState {
  final String message;
  const ValidateAndChangePasswordSuccess({required this.message});
}

class ValidateAndChangePasswordFailed extends CustomerState {
  final String error;
  const ValidateAndChangePasswordFailed({required this.error});
}

class UpdateLocationLoading extends CustomerState {}

class UpdateLocationSuccess extends CustomerState {}

class UpdateLiveLocationLoading extends CustomerState {}

class UpdateLiveLocationSuccess extends CustomerState {}

class UpdateLiveLocationFailed extends CustomerState {
  final String error;
  const UpdateLiveLocationFailed({required this.error});
}

class UpdateParentLoading extends CustomerState {}

class UpdateParentSuccess extends CustomerState {}

class UpdateParentFailed extends CustomerState {
  final String error;
  const UpdateParentFailed({required this.error});
}

class SearchForUserLoading extends CustomerState {}

class SearchForUserSuccess extends CustomerState {}

class SearchForUserFailed extends CustomerState {
  final String error;
  const SearchForUserFailed({required this.error});
}

class DeleteAccountLoading extends CustomerState {}

class DeleteAccountSuccess extends CustomerState {}

class DeleteAccountFailed extends CustomerState {
  final String error;
  const DeleteAccountFailed({
    required this.error,
  });
}

class UploadAvatarLoading extends CustomerState {}

class UploadAvatarSuccess extends CustomerState {}

class UploadAvatarFailed extends CustomerState {
  final String error;
  const UploadAvatarFailed({required this.error});
}

class UpdateAvatarLoading extends CustomerState {}

class UpdateAvatarSuccess extends CustomerState {}

class UpdateAvatarFailed extends CustomerState {
  final String error;
  const UpdateAvatarFailed({required this.error});
}

class UploadVoiceMessageLoading extends CustomerState {}

class UploadVoiceMessageSuccess extends CustomerState {}

class UploadVoiceMessageFailed extends CustomerState {
  final String error;
  const UploadVoiceMessageFailed({required this.error});
}

class UpdateUserMobileLoading extends CustomerState {}

class UpdateUserMobileSuccess extends CustomerState {}

class UpdateUserMobileFailed extends CustomerState {
  final String error;
  const UpdateUserMobileFailed({required this.error});
}

class UpdateUserAreaLoading extends CustomerState {}

class UpdateUserAreaSuccess extends CustomerState {}

class UpdateUserAreaFailed extends CustomerState {
  final String error;
  const UpdateUserAreaFailed({required this.error});
}
