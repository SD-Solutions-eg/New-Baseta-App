import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'apple_state.dart';

class AppleCubit extends Cubit<AppleState> {
  final FirebaseRepository firebaseRepo;
  final UserRepository userRepo;
  final InternetCubit connection;
  AppleCubit(
    this.userRepo,
    this.firebaseRepo,
    this.connection,
  ) : super(AppleInitial()) {
    isAppleSignInAvailable();
  }
  static AppleCubit get(BuildContext context) => BlocProvider.of(context);

  bool isAvailable = false;
  static bool isNewUser = false;

  Future<void> isAppleSignInAvailable() async {
    isAvailable = await SignInWithApple.isAvailable();
  }

  Future<void> appleLogin() async {
    emit(AppleSignInLoading());
    isNewUser = false;
    if (connection.state is InternetConnectionFail) {
      emit(AppleSignInFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        final userCredentials = await firebaseRepo.appleSignIn();
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
          emit(AppleSignInSuccess());
        }
      } catch (e) {
        log(' Apple Sign in Error: $e');
        if (e.toString() == 'Exception: CANCELLED') {
          emit(AppleSignInCancelled());
        } else {
          emit(AppleSignInFailed(error: e.toString()));
        }
      }
    }
  }
}
