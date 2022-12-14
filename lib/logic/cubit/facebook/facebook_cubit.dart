import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/data/repositories/firebase_repository.dart';
import 'package:allin1/data/repositories/user_repository.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'facebook_state.dart';

class FacebookCubit extends Cubit<FacebookState> {
  final UserRepository userRepo;
  final FirebaseRepository firebaseRepos;
  final InternetCubit connection;

  FacebookCubit(
    this.userRepo,
    this.firebaseRepos,
    this.connection,
  ) : super(FacebookInitial());

  static FacebookCubit get(BuildContext context) => BlocProvider.of(context);

  static bool isNewUser = false;

  Future<void> facebookLogin() async {
    emit(FacebookLoading());
    isNewUser = false;
    if (connection.state is InternetConnectionFail) {
      emit(FacebookFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userCredentials = await firebaseRepos.facebookSignIn();
        late final UserModel userModel;
        if (userCredentials.user != null) {
          if (userCredentials.additionalUserInfo!.isNewUser) {
            isNewUser = true;
            final generatedKey = Random().nextInt(99);
            final username =
                '${userCredentials.user!.email!.split('@').first}$generatedKey';
            userModel = await userRepo.registerUser(
              username,
              userCredentials.user!.email!,
              userCredentials.user!.uid,
            );
            await userCredentials.user!
                .updateDisplayName(userModel.id.toString());
          } else {
            final id = int.tryParse(userCredentials.user!.displayName!);
            if (id != null) {
              userModel = await userRepo.getUserModel(id: id);
            } else {
              userModel = await userRepo.getUserByEmail(
                email: userCredentials.user!.email!,
              );
              userCredentials.user!.updateDisplayName(userModel.id.toString());
              await userRepo.updatePassword(
                userCredentials.user!.uid,
                userModel.id,
              );
            }
            final myCredentials =
                'Basic ${base64Encode(utf8.encode('${userCredentials.user!.email!}:${userCredentials.user!.uid}'))}';
            await hydratedStorage.write(userCredentialsTxt, myCredentials);
            FirebaseAuthBloc.userBasicAuth = myCredentials;
          }
          hydratedStorage.write('isSocialUser', true);
          FirebaseAuthBloc.socialUser = true;
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
          emit(FacebookSuccess());
        }
      } catch (e) {
        print(' Facebook Error: $e');
        emit(FacebookFailed(error: e.toString()));
      }
    }
  }
}
