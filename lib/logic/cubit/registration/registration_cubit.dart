import 'dart:developer';

import 'package:allin1/core/constants/firebase_exception.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/repositories/firebase_repository.dart';
import 'package:allin1/data/repositories/user_repository.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final UserRepository userRepo;
  final FirebaseRepository firebaseRepo;
  final InternetCubit connection;
  RegistrationCubit(
    this.userRepo,
    this.firebaseRepo,
    this.connection,
  ) : super(RegistrationInitial());

  static RegistrationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> registerUser(
    BuildContext context, {
    required String phone,
    required String password,
  }) async {
    emit(RegistrationLoading());
    if (connection.state is InternetConnectionFail) {
      emit(RegistrationFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final email = '$phone@basita.app';
        final firebaseUser =
            await firebaseRepo.register(email: email, password: password);
        final userModel = await userRepo.registerUser(phone, email, password);
        await firebaseUser.updateDisplayName(userModel.id.toString());

        FirebaseAuthBloc.currentUser = userModel;

        await hydratedStorage.write('UID', userModel.id);

        try {
          final deviceToken = await FirebaseMessaging.instance.getToken();
          if (deviceToken != null) {
            final updateTokenMessage = await userRepo.setDeviceFCMToken(
              id: userModel.id,
              token: deviceToken,
            );
            log(updateTokenMessage);
          }
        } catch (e) {
          log('Send FCM Token error: $e');
        }

        emit(RegistrationSuccess());
      } on FirebaseAuthException catch (e) {
        print(' Registration Error Firebase exception: $e');
        if (e.code == 'email-already-in-use' ||
            e.code == 'registration-error-username-exists') {
          final isArabic = Languages.of(context) is LanguageAr;
          emit(RegistrationFailed(
              error: isArabic
                  ? 'رقم الهاتف مستخدم بالفعل من قبل حساب آخر ، حاول تسجيل الدخول'
                  : 'The mobile number is already in use by another account, try to login'));
        } else {
          final message = translateFirebaseMessage(context,
              code: e.code, message: e.message);
          if (message != null) {
            emit(RegistrationFailed(error: message));
          } else {
            emit(RegistrationFailed(error: e.message ?? e.code));
          }
        }
      } catch (e) {
        final isArabic = Languages.of(context) is LanguageAr;

        print(' register Error: $e');
        if (e.toString().contains('that username already exists')) {
          emit(RegistrationFailed(
              error: isArabic
                  ? 'رقم الهاتف مستخدم بالفعل من قبل حساب آخر ، حاول تسجيل الدخول'
                  : 'The mobile number is already in use by another account, try to login'));
        } else {
          emit(RegistrationFailed(error: e.toString()));
        }
      }
    }
  }
}
