// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/data/repositories/firebase_repository.dart';
import 'package:allin1/data/repositories/user_repository.dart';
import 'package:allin1/logic/cubit/information/information_cubit.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:allin1/logic/cubit/notifications/notifications_cubit.dart';
import 'package:allin1/logic/cubit/orders/orders_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'firebase_auth_event.dart';
part 'firebase_auth_state.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  final FirebaseRepository firebaseRepo;
  final InternetCubit connection;
  final UserRepository userRepo;
  final NotificationsCubit _notificationsCubit;
  final OrdersCubit ordersCubit;

  FirebaseAuthBloc(
    this.firebaseRepo,
    this.connection,
    this.userRepo,
    this._notificationsCubit,
    this.ordersCubit,
  ) : super(FirebaseAuthInitial());

  static FirebaseAuthBloc get(BuildContext context) => BlocProvider.of(context);

  StreamSubscription<User?>? userStreamSubscription;
  static UserModel? currentUser;
  static String? fcmToken;
  static User? firebaseUser;
  bool? isVerified;
  int? cachedUID;
  static String? userBasicAuth;

  static bool socialUser = false;

  @override
  Stream<FirebaseAuthState> mapEventToState(
    FirebaseAuthEvent event,
  ) async* {
    if (event is InitialEvent) {
      yield AuthCheckLoading();
      userBasicAuth = hydratedStorage.read(userCredentialsTxt) as String?;
      if (connection.state is InternetConnectionFail) {
        yield AuthCheckFailed(LanguageAr().connectionFailed);
      } else {
        socialUser =
            await hydratedStorage.read('isSocialUser') as bool? ?? false;
        try {
          final int? id = await hydratedStorage.read('UID') as int?;
          if (id != null) {
            final userModel = await userRepo.getUserModel(id: id);
            currentUser = userModel;

            emit(AuthCheckSuccess(userModel: currentUser!));
          } else {
            emit(AuthCheckUnauthenticated());
          }
        } catch (e) {
          print(e);
          yield AuthCheckFailed(e.toString());
        }
      }
    } else if (event is VerifyEmailEvent) {
      yield VerificationMailLoading();
      try {
        await firebaseRepo.sendEmailVerification();

        yield VerificationMailSent();
      } catch (e) {
        // log('Verification Failed : $e');
        yield VerificationMailFailed(error: e.toString());
      }
    } else if (event is SignOutEvent) {
      yield AuthCheckLoading();
      if (connection.state is InternetConnectionFail) {
        yield AuthCheckFailed(LanguageAr().connectionFailed);
      } else {
        try {
          await hydratedStorage.delete('UID');
          await firebaseRepo.logOut();
          _notificationsCubit.clearUserData();
          currentUser = null;
          firebaseUser = null;
          socialUser = false;
          userBasicAuth = null;
          ordersCubit.clearUserData();
          InformationCubit.logout();
          hydratedStorage.delete(userCredentialsTxt);
          hydratedStorage.delete('isSocialUser');
          yield AuthCheckUnauthenticated();
        } catch (e) {
          yield AuthCheckFailed(e.toString());
        }
      }
    } else if (event is DeleteUserEvent) {
      yield AuthCheckLoading();
      if (connection.state is InternetConnectionFail) {
        yield AuthCheckFailed(LanguageAr().connectionFailed);
      } else {
        try {
          await hydratedStorage.delete('UID');
          await firebaseRepo.deleteUser();
          await firebaseRepo.logOut();
          _notificationsCubit.clearUserData();
          firebaseUser = null;
          currentUser = null;
          hydratedStorage.delete(bearerTxt);
          socialUser = false;
          yield AuthCheckUnauthenticated();
        } catch (e) {
          yield AuthCheckFailed(e.toString());
        }
      }
    }
  }

  @override
  Future<void> close() {
    userStreamSubscription?.cancel();
    return super.close();
  }
}
