import 'dart:developer';

import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/repositories/firebase_repository.dart';
import 'package:allin1/data/repositories/user_repository.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepo;
  final FirebaseRepository firebaseRepo;
  final InternetCubit connection;

  LoginCubit(
    this.userRepo,
    this.connection,
    this.firebaseRepo,
  ) : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> login(
    BuildContext context, {
    required String phone,
    required String password,
  }) async {
    emit(LoginLoading());
    if (connection.state is InternetConnectionFail) {
      emit(LoginFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userModel = await userRepo.login(phone, password);
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

        emit(LoginSuccess());
      } catch (e) {
        final isArabic = Languages.of(context) is LanguageAr;
        print(' Login Error: $e');
        if (e.toString().contains('invalid_username') ||
            e.toString().contains('is not registered on this site')) {
          emit(LoginFailed(
              error: isArabic
                  ? 'لا يوجد حساب مسجل بهذا الرقم  $phone'
                  : 'The number $phone is not registered on this application'));
        } else if (e
                .toString()
                .contains('The password you entered for the username') ||
            e.toString().contains('incorrect_password')) {
          emit(LoginFailed(
              error: isArabic
                  ? 'رقم الهاتف او كلمة المرور غير صحيحة'
                  : 'Wrong mobile number or password'));
        } else {
          emit(LoginFailed(error: e.toString()));
        }
      }
    }
  }
}
