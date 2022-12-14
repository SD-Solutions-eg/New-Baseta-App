part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthEvent extends Equatable {
  const FirebaseAuthEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends FirebaseAuthEvent {}

class SendVerificationCodeEvent extends FirebaseAuthEvent {}

class VerifyEmailEvent extends FirebaseAuthEvent {}

class SignOutEvent extends FirebaseAuthEvent {}

class DeleteUserEvent extends FirebaseAuthEvent {}
