import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/page_model.dart';
import 'package:allin1/data/models/sms_response_model.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/data/repositories/user_repository.dart';
import 'package:allin1/data/services/firebase_auth_services.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/category/category_cubit.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final UserRepository userRepo;
  final InternetCubit connection;
  CustomerCubit(
    this.userRepo,
    this.connection,
  ) : super(CustomerInitial());

  static CustomerCubit get(BuildContext context) => BlocProvider.of(context);

  String? verificationId;
  String? phoneNumber;
  int? resendingToken;
  PageModel? privacyPolicy;
  PageModel? terms;
  PageModel? shippingPolicy;
  PageModel? returnPolicy;
  int? searchedForUserId;
  static int? currentLocationIndex;
  List<LocationModel> newLocations = [];
  static LocationModel? selectedLocation;

  Future<void> updateSelectedLocation(LocationModel location) async {
    selectedLocation = location;
    emit(UpdateLocationLoading());
    emit(UpdateLocationSuccess());
  }

  Future<void> getCustomer() async {
    emit(CustomerGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(CustomerGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final user = await userRepo.getUserModel(id: 1);
        FirebaseAuthBloc.currentUser = user;
        emit(CustomerGetSuccess());
      } catch (e) {
        emit(CustomerGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    emit(CustomerUpdateLoading());
    if (connection.state is InternetConnectionFail) {
      emit(CustomerUpdateFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final updatedUserModel = await userRepo.updateUser(
          id: userModel.id,
          userModel: userModel,
        );
        FirebaseAuthBloc.currentUser = updatedUserModel;
        emit(CustomerUpdateSuccess());
      } catch (e) {
        emit(CustomerUpdateFailed(error: e.toString()));
      }
    }
  }

  Future<void> updateCustomerName(
      {required String firstName,
      required String lastName,
      String? email}) async {
    emit(CustomerUpdateLoading());
    if (connection.state is InternetConnectionFail) {
      emit(CustomerUpdateFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userModel = FirebaseAuthBloc.currentUser;
        if (userModel != null) {
          if (email != null && email.isNotEmpty) {
            await FirebaseAuthenticationServices().changeFirebaseEmail(email);
          }
          final updatedUserModel = await userRepo.updateUserNameAndEmail(
            id: userModel.id,
            firstName: firstName,
            lastName: lastName,
            email: email,
          );
          FirebaseAuthBloc.currentUser = updatedUserModel;
          emit(CustomerUpdateSuccess());
        } else {
          emit(const CustomerUpdateFailed(error: 'Failed to get user data'));
        }
      } catch (e) {
        emit(CustomerUpdateFailed(error: e.toString()));
      }
    }
  }

  Future<void> searchForUserByMobileNumber(String mobileNumber) async {
    searchedForUserId = null;
    emit(SearchForUserLoading());
    if (connection.state is InternetConnectionFail) {
      emit(SearchForUserFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userId = await userRepo.searchForUserByMobileNumber(
            mobileNumber: mobileNumber);
        if (userId != -1) {
          searchedForUserId = userId;
          emit(SearchForUserSuccess());
        } else {
          searchedForUserId = null;
          emit(const SearchForUserFailed(
              error: "There is no user with this mobile number!"));
        }
      } catch (e) {
        log('Search For User Error: $e');
        emit(SearchForUserFailed(error: e.toString()));
      }
    }
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      await userRepo.deleteAccount();
      emit(DeleteAccountSuccess());
    } catch (e) {
      emit(DeleteAccountFailed(error: e.toString()));
    }
  }

  Future<void> verifyPhoneNumber({required String phoneNumber}) async {
    emit(VerifyPhoneLoading());
    this.phoneNumber = phoneNumber;
    if (connection.state is InternetConnectionFail) {
      emit(VerifyPhoneFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: _verificationCompleted,
          verificationFailed: _verificationFailed,
          codeSent: _codeSent,
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      } catch (e) {
        emit(VerifyPhoneFailed(error: e.toString()));
      }
    }
  }

  Future<void> sendSmsOtp({required String phoneNumber}) async {
    emit(SendSmsLoading());
    this.phoneNumber = phoneNumber;
    if (connection.state is InternetConnectionFail) {
      emit(SendSmsFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final SMSResponseModel result =
            await userRepo.sendSmsOtp(phoneNumber: phoneNumber);
        print('type: ${result.type}');
        if (result.type == 'success') {
          emit(SendSmsSuccess());
        } else {
          emit(SendSmsFailed(error: result.msg));
        }
      } catch (e) {
        emit(SendSmsFailed(error: e.toString()));
      }
    }
  }

  Future<void> checkSmsOtp(
      {required String phoneNumber, required String otp}) async {
    emit(CheckOtpLoading());
    this.phoneNumber = phoneNumber;
    if (connection.state is InternetConnectionFail) {
      emit(CheckOtpFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final SMSResponseModel result =
            await userRepo.checkSmsOtp(phoneNumber: phoneNumber, otp: otp);
        if (result.type == 'success') {
          emit(CheckOtpSuccess());
        } else {
          emit(CheckOtpFailed(error: result.msg));
        }
      } catch (e) {
        emit(CheckOtpFailed(error: e.toString()));
      }
    }
  }

  Future<void> resendVerificationCode() async {
    emit(ReverifyPhoneLoading());
    if (connection.state is InternetConnectionFail) {
      emit(ReverifyPhoneFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        FirebaseAuth.instance.verifyPhoneNumber(
          forceResendingToken: resendingToken,
          phoneNumber: phoneNumber,
          verificationCompleted: _verificationCompleted,
          verificationFailed: _verificationFailed,
          codeSent: _codeResent,
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      } catch (e) {
        emit(ReverifyPhoneFailed(error: e.toString()));
      }
    }
  }

  Future<void> verifyOTP(String code) async {
    emit(VerifyOTPLoading());
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userCredential = await FirebaseAuth.instance.currentUser!
            .linkWithCredential(credential);
        log('User is: ${userCredential.user}');
      } else {
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        await FirebaseAuth.instance.signOut();
        log('phone credentials  is: ${userCredential.user}');
      }
      emit(VerifyOTPSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        emit(VerifyOTPSuccess());
      } else if (e.code == 'invalid-verification-code') {
        emit(const VerifyPhoneFailed(error: 'Invalid verification code'));
      } else if (e.code == 'credential-already-in-use') {
        emit(const VerifyPhoneFailed(error: 'Phone number already in use'));
      } else if (e.message != null &&
          e.message ==
              'com.google.firebase.FirebaseException: User has already been linked to the given provider.') {
        emit(VerifyOTPSuccess());
      } else if (e.message != null &&
          e.message ==
              'com.google.firebase.j: User has already been linked to the given provider.') {
        emit(VerifyOTPSuccess());
      } else if (e.message != null &&
          e.message!
              .contains('User has already been linked to the given provider')) {
        emit(VerifyOTPSuccess());
      } else {
        log(e.code);

        emit(VerifyPhoneFailed(error: e.message ?? e.code));
      }
    } catch (e) {
      log(e.toString());
      emit(VerifyPhoneFailed(error: e.toString()));
    }
  }

  Future<void> _verificationCompleted(
      PhoneAuthCredential authCredential) async {
    try {
      final userCredential = await FirebaseAuth.instance.currentUser!
          .linkWithCredential(authCredential);
      log('User is: ${userCredential.user}');
      emit(VerifyOTPSuccess());
    } on FirebaseAuthException catch (e) {
      emit(VerifyPhoneFailed(error: e.message ?? e.code));
    } catch (e) {
      emit(const VerifyPhoneFailed(error: 'Wrong Code'));
    }
  }

  void _verificationFailed(FirebaseAuthException authException) {
    log(authException.toString());
    if (authException.code == 'missing-client-identifier') {
      emit(
        const VerifyPhoneFailed(
          error:
              'Neither SafetyNet checks nor reCAPTCHA checks succeeded, Please try again',
        ),
      );
    } else {
      emit(
        VerifyPhoneFailed(
          error: authException.message ?? authException.code,
        ),
      );
    }
  }

  void _codeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    resendingToken = forceResendingToken;
    log('Code Sent : $forceResendingToken');
    emit(VerifyPhoneSent());
  }

  void _codeResent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    resendingToken = forceResendingToken;
    log('Code Sent : $forceResendingToken');
    emit(ReverifyPhoneSent());
  }

  Future<void> updatePassword(
      {required String newPassword, int? userId}) async {
    emit(UpdatePasswordLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UpdatePasswordFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userModel = FirebaseAuthBloc.currentUser;
        if (userModel != null) {
          await userRepo.updatePassword(newPassword, userModel.id);
          emit(UpdatePasswordSuccess());
        } else if (userId != null) {
          await userRepo.updatePassword(newPassword, userId);
          emit(UpdatePasswordSuccess());
        } else {
          emit(const UpdatePasswordFailed(error: 'Failed to get user data'));
        }
      } catch (e) {
        log(e.toString());
        emit(UpdatePasswordFailed(error: e.toString()));
      }
    }
  }

  Future<bool> validatePassword({required String currentPassword}) async {
    final auth = FirebaseAuth.instance;
    try {
      final credential = EmailAuthProvider.credential(
        email: auth.currentUser!.email!,
        password: currentPassword,
      );
      final userCredentials =
          await auth.currentUser!.reauthenticateWithCredential(credential);

      return userCredentials.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> getPrivacyPolicy() async {
    emit(PrivacyGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(PrivacyGetFailed(error: LanguageAr().connectionFailed));
    } else {
      if (privacyPolicy != null) {
        emit(PrivacyGetSuccess());
      } else {
        try {
          privacyPolicy = await userRepo.getPolicyByEP(
            policyEP: privacyEP,
            policyName: 'policy_app',
            policyImageName: 'policy_image',
            policyImageEP: privacyImageEP,
          );
          emit(PrivacyGetSuccess());
        } catch (e) {
          log(e.toString());
          emit(PrivacyGetFailed(error: e.toString()));
        }
      }
    }
  }

  Future<void> getTermsAndConditions() async {
    emit(TermsGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(TermsGetFailed(error: LanguageAr().connectionFailed));
    } else {
      if (terms != null) {
        emit(TermsGetSuccess());
      } else {
        try {
          terms = await userRepo.getPolicyByEP(
            policyEP: termsEP,
            policyName: 'terms',
            policyImageName: 'terms_image',
            policyImageEP: termsImageEP,
          );
          emit(TermsGetSuccess());
        } catch (e) {
          log(e.toString());
          emit(TermsGetFailed(error: e.toString()));
        }
      }
    }
  }

  Future<void> getShippingPolicy() async {
    emit(ShippingPolicyGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(ShippingPolicyGetFailed(error: LanguageAr().connectionFailed));
    } else {
      if (shippingPolicy != null) {
        emit(ShippingPolicyGetSuccess());
      } else {
        try {
          shippingPolicy = await userRepo.getPolicyByEP(
            policyEP: shippingEP,
            policyName: 'shipping_policy',
            policyImageName: 'shipping_policy_image',
            policyImageEP: shippingImageEP,
          );
          emit(ShippingPolicyGetSuccess());
        } catch (e) {
          log(e.toString());
          emit(ShippingPolicyGetFailed(error: e.toString()));
        }
      }
    }
  }

  Future<void> getReturnPolicy() async {
    emit(ReturnPolicyGetLoading());
    if (connection.state is InternetConnectionFail) {
      emit(ReturnPolicyGetFailed(error: LanguageAr().connectionFailed));
    } else {
      if (returnPolicy != null) {
        emit(ReturnPolicyGetSuccess());
      } else {
        try {
          returnPolicy = await userRepo.getPolicyByEP(
            policyEP: returnEP,
            policyName: 'return_policy',
            policyImageName: 'return_policy_image',
            policyImageEP: returnImageEP,
          );
          emit(ReturnPolicyGetSuccess());
        } catch (e) {
          log(e.toString());
          emit(ReturnPolicyGetFailed(error: e.toString()));
        }
      }
    }
  }

  Future<void> sendResetPasswordEmail({required String email}) async {
    emit(ResetPasswordLoading());
    if (connection.state is InternetConnectionFail) {
      emit(ResetPasswordFailed(error: LanguageAr().connectionFailed));
    } else {
      emit(ResetPasswordLoading());
      try {
        final message = await userRepo.sendPasswordResetEmail(email: email);
        emit(ResetPasswordSuccess(message: message));
      } catch (e) {
        emit(ResetPasswordFailed(error: e.toString()));
      }
    }
  }

  Future<void> validateAndChangePassword(
      {required String email,
      required String code,
      required String newPassword}) async {
    emit(ValidateAndChangePasswordLoading());
    if (connection.state is InternetConnectionFail) {
      emit(
        ValidateAndChangePasswordFailed(
          error: LanguageAr().connectionFailed,
        ),
      );
    } else {
      emit(ValidateAndChangePasswordLoading());
      try {
        final message = await userRepo.validateAndChangePassword(
          email: email,
          code: code,
          newPassword: newPassword,
        );
        emit(ValidateAndChangePasswordSuccess(message: message));
      } catch (e) {
        emit(ValidateAndChangePasswordFailed(error: e.toString()));
      }
    }
  }

  Future<void> updateMyLocations(
      {required Map<String, dynamic> locationsMap}) async {
    emit(UpdateLiveLocationLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UpdateLiveLocationFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userModel = FirebaseAuthBloc.currentUser;
        if (userModel != null) {
          log('New Live location Map: $locationsMap');
          newLocations = await userRepo.updateMyLocations(
            id: userModel.userData.dataId,
            locationsMap: locationsMap,
          );
          log('Response of Location updated Model: $newLocations');
          FirebaseAuthBloc.currentUser = userModel.copyWith(
            userData: userModel.userData.copyWith(locations: newLocations),
          );
        }
        emit(UpdateLiveLocationSuccess());
      } catch (e) {
        log('Update Live Location Data Error: $e');
        emit(UpdateLiveLocationFailed(error: e.toString()));
      }
    }
  }

  Future<Map<String, dynamic>?> uploadImageFile(File pickedFile) async {
    emit(UploadAvatarLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UploadAvatarFailed(error: CategoryCubit.appText!.connectionFailed));
      return null;
    } else {
      try {
        final imageData = await userRepo.uploadImageFile(pickedFile);
        final imageId = imageData['id'] as int;
        final imageUrl = imageData['image'] as String;
        emit(UploadAvatarSuccess());
        return {
          'id': imageId,
          'image': imageUrl,
        };
      } catch (e) {
        log('Upload Image Error: $e');
        emit(UploadAvatarFailed(error: e.toString()));
        return null;
      }
    }
  }

  Future<void> updateUserAvatar(int avatarId) async {
    emit(UpdateAvatarLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UpdateAvatarFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        if (FirebaseAuthBloc.currentUser != null) {
          final userModel = await userRepo.updateUserAvatar(
            id: FirebaseAuthBloc.currentUser!.id,
            avatarId: avatarId,
            // token: FirebaseAuthBloc.userBasicAuth!,
          );
          FirebaseAuthBloc.currentUser = userModel;
        }
        emit(UpdateAvatarSuccess());
      } catch (e) {
        log('Update Avatar Error: $e');
        emit(UpdateAvatarFailed(error: e.toString()));
      }
    }
  }

  Future<Map<String, dynamic>?> uploadVoiceMessage(File pickedFile) async {
    emit(UploadVoiceMessageLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UploadVoiceMessageFailed(
          error: CategoryCubit.appText!.connectionFailed));
      return null;
    } else {
      try {
        final voiceData = await userRepo.uploadVoiceMessage(pickedFile);
        emit(UploadVoiceMessageSuccess());
        final voiceId = voiceData['id'] as int;
        final voiceUrl = voiceData['voice'] as String;
        return {
          'id': voiceId,
          'voice': voiceUrl,
        };
      } catch (e) {
        log('UploadVoiceMessage Error: $e');
        emit(UploadVoiceMessageFailed(error: e.toString()));
        return null;
      }
    }
  }

  Future<void> updateUserMobile(
      {required int id, required String mobile}) async {
    emit(UpdateUserMobileLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UpdateUserMobileFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userModel = FirebaseAuthBloc.currentUser;
        if (userModel != null) {
          final mobileMap = {
            'fields': {
              'mobile': mobile,
            },
          };
          final updatedUserData = await userRepo.updateUserIndividualData(
            id: userModel.userData.dataId,
            map: mobileMap,
          );
          FirebaseAuthBloc.currentUser = userModel.copyWith(
            userData: updatedUserData,
          );
        }
        emit(UpdateUserMobileSuccess());
      } catch (e) {
        log('UpdateUserMobile Error: $e');
        emit(UpdateUserMobileFailed(error: e.toString()));
      }
    }
  }

  Future<void> updateUserArea({required int id, required int areaId}) async {
    emit(UpdateUserAreaLoading());
    if (connection.state is InternetConnectionFail) {
      emit(UpdateUserAreaFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userModel = FirebaseAuthBloc.currentUser;
        if (userModel != null) {
          final areaMap = {
            'fields': {
              'area': areaId,
            },
          };
          final updatedUserData = await userRepo.updateUserIndividualData(
            id: userModel.userData.dataId,
            map: areaMap,
          );
          FirebaseAuthBloc.currentUser = userModel.copyWith(
            userData: updatedUserData,
          );
        }
        emit(UpdateUserAreaSuccess());
      } catch (e) {
        log('UpdateUserArea Error: $e');
        emit(UpdateUserAreaFailed(error: e.toString()));
      }
    }
  }
}
