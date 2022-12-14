import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/page_model.dart';
import 'package:allin1/data/models/sms_response_model.dart';
import 'package:allin1/data/models/user_model.dart';
import 'package:allin1/data/services/authentication_services.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:intl/intl.dart' as intl;

class UserRepository {
  final AuthenticationServices _apiServices;
  UserRepository(this._apiServices);

  Future<UserModel> getUserModel({required int id}) async {
    try {
      final customerData = await _apiServices.getUserModel(id: id);

      final userModel = UserModel.fromMap(customerData);

      log('User ID: $id');

      final userDataModel = await getUserData(id: id);

      final newUserModel = userModel.copyWith(
        userData: userDataModel ?? userModel.userData,
      );

      log('User Data Model : $userDataModel');

      return newUserModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDataModel?> getUserData({required int id}) async {
    try {
      final userData = await _apiServices.getUserDataModel(id: id);
      if (userData.isNotEmpty) {
        final userDataModel = UserDataModel.fromMap(userData);
        return userDataModel;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUser({
    required int id,
    required UserModel userModel,
  }) async {
    try {
      final userJson = json.encode(userModel.toMap());

      final updatedUserData = await _apiServices.updateUserData(
        id: id,
        customerJson: userJson,
      );
      final updatedUserModel = UserModel.fromMap(updatedUserData);

      final newUserModel = updatedUserModel.copyWith(
        userData: userModel.userData,
      );

      return newUserModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUserNameAndEmail({
    required int id,
    required String firstName,
    required String lastName,
    required String? email,
  }) async {
    try {
      final String userJson;
      if (email != null && email.isNotEmpty) {
        userJson = json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        });
      } else {
        userJson = json.encode({
          'first_name': firstName,
          'last_name': lastName,
        });
      }

      final updatedUserData = await _apiServices.updateUserData(
        id: id,
        customerJson: userJson,
      );
      final updatedUserModel = UserModel.fromMap(updatedUserData);
      final userDataModel = await getUserData(id: id);

      final newUserModel = updatedUserModel.copyWith(
        userData: userDataModel,
      );

      return newUserModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> registerUser(
      String username, String email, String uid) async {
    try {
      final userMap = await _apiServices.registration(
        email: email,
        uid: uid,
        username: username,
      );
      final userModel = UserModel.fromMap(userMap);
      final myCredentials = 'Basic ${base64Encode(utf8.encode('$email:$uid'))}';
      final userDataModel = await createUserData(
          myCredentials: myCredentials, username: username);
      final newUserModel = userModel.copyWith(userData: userDataModel);
      log(newUserModel.toString());
      FirebaseAuthBloc.userBasicAuth = myCredentials;
      await hydratedStorage.write(userCredentialsTxt, myCredentials);

      return newUserModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDataModel> createUserData(
      {required String myCredentials, required String username}) async {
    try {
      final map = await _apiServices.createUserData(myCredentials, username);
      final userData = UserDataModel.fromMap(map);
      return userData;
    } catch (e) {
      log('Failed to create User Data');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _apiServices.deleteAccount(
        myCredentials: FirebaseAuthBloc.userBasicAuth!,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(String email, String passwordOrUID) async {
    try {
      final userData = await _apiServices.login(
        email: email,
        passwordOrUid: passwordOrUID,
      );
      final userModel = UserModel.fromMap(userData);
      final myCredentials =
          'Basic ${base64Encode(utf8.encode('$email:$passwordOrUID'))}';
      FirebaseAuthBloc.userBasicAuth = myCredentials;
      await hydratedStorage.write(userCredentialsTxt, myCredentials);

      final userDataModel = await getUserData(id: userModel.id);

      final newUserModel = userModel.copyWith(
        userData: userDataModel,
      );

      return newUserModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> searchForUserByMobileNumber(
      {required String mobileNumber}) async {
    try {
      final response = await _apiServices.searchForUserByMobileNumber(
          mobileNumber: mobileNumber);
      final userData = json.decode(response) as List;
      if (userData.isNotEmpty) {
        return (userData.first as Map<String, dynamic>)['id'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(
    String newPassword,
    int id,
  ) async {
    try {
      final newPasswordJson = json.encode({
        'password': newPassword,
      });
      await _apiServices.updatePassword(newPasswordJson, id);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserByEmail({required String email}) async {
    try {
      final userData = await _apiServices.getUserByEmail(email: email);

      final userModel = UserModel.fromMap(userData);

      final userDataModel = await getUserData(id: userModel.id);

      final newUserModel = userModel.copyWith(
        userData: userDataModel,
      );

      return newUserModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<PageModel> getPolicyByEP({
    required String policyEP,
    required String policyName,
    required String policyImageName,
    required String policyImageEP,
  }) async {
    try {
      final unFormattedString =
          await _apiServices.getPolicyByEP(policyEP: policyEP);
      final policyJson = intl.Bidi.stripHtmlIfNeeded(unFormattedString);
      final policyData = json.decode(policyJson) as Map<String, dynamic>;

      final content = policyData[policyName] as String? ?? '';
      final image = await _getPolicyImageByEP(policyImageEP, policyImageName);

      final policyModel = PageModel(content: content, image: image);

      return policyModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<PageImageModel?> _getPolicyImageByEP(
      String policyImageEP, String policyImageName) async {
    try {
      final policyImageJson =
          await _apiServices.getPolicyImageByEP(policyImageEP: policyImageEP);
      final policyImageData =
          json.decode(policyImageJson) as Map<String, dynamic>;
      final imageData = policyImageData[policyImageName];
      if (imageData is Map) {
        final policyImage = PageImageModel.fromMap(
          imageData as Map<String, dynamic>,
        );
        return policyImage;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      final responseData = await _apiServices.sendPasswordResetEmail(email);
      final message = (json.decode(responseData)
          as Map<String, dynamic>)['message'] as String;
      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> validateAndChangePassword(
      {required String email,
      required String code,
      required String newPassword}) async {
    try {
      final responseData = await _apiServices.validateAndChangePassword(
        email,
        code,
        newPassword,
      );
      final message = (json.decode(responseData)
          as Map<String, dynamic>)['message'] as String;
      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> setDeviceFCMToken(
      {required int id, required String token}) async {
    try {
      final responseData = await _apiServices.setDeviceFCMToken(id, token);
      final message = (json.decode(responseData)
          as Map<String, dynamic>)['message'] as String;
      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDataModel> updateUserIndividualData({
    required int id,
    required Map<String, dynamic> map,
  }) async {
    try {
      final dataJson = json.encode(map);

      final updatedUserData = await _apiServices.updateUserMobile(
        dataId: id,
        dataJson: dataJson,
      );
      final updateUserDataModel = UserDataModel.fromMap(updatedUserData);
      return updateUserDataModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocationModel>> updateMyLocations({
    required int id,
    required Map<String, dynamic> locationsMap,
  }) async {
    try {
      final locationsJson = json.encode(locationsMap);

      final updateLocationData = await _apiServices.updateMyLocations(
        dataId: id,
        locationsJson: locationsJson,
      );
      final locationsData = updateLocationData['acf']['locations'] as List;
      final List<LocationModel> myLocations = [];
      for (final map in locationsData) {
        final locationModel =
            LocationModel.fromMap(map['location'] as Map<String, dynamic>);
        myLocations.add(locationModel);
      }
      return myLocations;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadImageFile(File pickedFile) async {
    try {
      final fileName = pickedFile.path.split('/').last;
      final imageBytes = File(pickedFile.path).readAsBytesSync();
      final response = await _apiServices.uploadImage(
          fileName: fileName, imageBytes: imageBytes);
      final imageData = json.decode(response) as Map<String, dynamic>;
      final imageId = imageData['id'] as int;
      final imageUrl = imageData['source_url'] as String;
      log('Image ID: $imageId');
      log('Image URL: $imageUrl');
      return {
        'id': imageId,
        'image': imageUrl,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUserAvatar({
    required int id,
    required int avatarId,
    /*required String token*/
  }) async {
    try {
      final userData = await _apiServices.updateUserAvatar(
        id: id,
        avatarId: avatarId,
        // token: token,
      );

      final userModel = UserModel.fromMap(userData);
      log('User Model: ${userModel.avatarUrl}');
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadVoiceMessage(File pickedFile) async {
    try {
      final fileName = pickedFile.path.split('/').last;
      final audioBytes = File(pickedFile.path).readAsBytesSync();
      final response = await _apiServices.uploadVoiceMessage(
          fileName: fileName, audioBytes: audioBytes);
      final voiceData = json.decode(response) as Map<String, dynamic>;
      final voiceId = voiceData['id'] as int;
      final voiceUrl = voiceData['source_url'] as String;
      log('Voice ID: $voiceId');
      log('Voice URL: $voiceUrl');
      return {
        'id': voiceId,
        'voice': voiceUrl,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<SMSResponseModel> sendSmsOtp({required String phoneNumber}) async {
    try {
      final result = await _apiServices.sendSmsOtp(phoneNumber: phoneNumber);
      final responseData = json.decode(result) as Map<String, dynamic>;
      final message = SMSResponseModel.fromJson(responseData);
      return message;
    } catch (e) {
      rethrow;
    }
  }

  Future<SMSResponseModel> checkSmsOtp(
      {required String phoneNumber, required String otp}) async {
    try {
      final result =
          await _apiServices.checkSmsOtp(phoneNumber: phoneNumber, otp: otp);
      final responseData = json.decode(result) as Map<String, dynamic>;
      final message = SMSResponseModel.fromJson(responseData);
      return message;
    } catch (e) {
      rethrow;
    }
  }
}
