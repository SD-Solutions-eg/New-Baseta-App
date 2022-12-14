import 'package:allin1/presentation/routers/import_helper.dart';

String? translateFirebaseMessage(BuildContext context,
    {required String code, required String? message}) {
  if (code == 'email-already-in-use') {
    return message;
  } else if (code == 'operation-not-allowed') {
    return message ?? code;
  } else if (code == 'invalid-email') {
    return message ?? code;
  } else if (code == 'weak-password') {
    return message ?? code;
  } else if (code == 'user-disabled') {
    return message ?? code;
  } else if (code == 'user-not-found') {
    return message ?? code;
  } else if (code == 'wrong-password') {
    return message ?? code;
  } else if (code == 'invalid-verification-code') {
    return message ?? code;
  } else if (code == 'invalid-verification-id') {
    return message ?? code;
  } else if (code == 'invalid-credential') {
    return message ?? code;
  } else if (code == 'auth/invalid-email') {
    return message ?? code;
  } else if (code == 'auth/user-not-found') {
    return message ?? code;
  }
}
