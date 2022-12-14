part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthState extends Equatable {
  const FirebaseAuthState();

  @override
  List<Object> get props => [];
}

class FirebaseAuthInitial extends FirebaseAuthState {}

/// Check Status Of The Current User
class AuthCheckLoading extends FirebaseAuthState {}

class AuthCheckUnverified extends FirebaseAuthState {}

class AuthCheckUnauthenticated extends FirebaseAuthState {}

class AuthCheckWaitingFirebase extends FirebaseAuthState {}

class AuthCheckSuccess extends FirebaseAuthState {
  final UserModel userModel;

  const AuthCheckSuccess({required this.userModel});
}

class AuthCheckFailed extends FirebaseAuthState {
  final String error;
  const AuthCheckFailed(this.error);
}

///  Sending Verification Mail To The User
class VerificationMailLoading extends FirebaseAuthState {}

class VerificationMailSent extends FirebaseAuthState {}

class VerificationMailFailed extends FirebaseAuthState {
  final String error;
  const VerificationMailFailed({required this.error});
}

/// Check If User Email Is Verified Or Not
class VerificationCheckLoading extends FirebaseAuthState {}

class VerificationCheckSuccess extends FirebaseAuthState {}

class VerificationCheckUnverified extends FirebaseAuthState {}

class VerificationCheckFailed extends FirebaseAuthState {
  final String error;
  const VerificationCheckFailed(this.error);
}
