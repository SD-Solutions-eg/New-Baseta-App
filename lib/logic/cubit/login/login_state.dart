part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginUnverified extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailed extends LoginState {
  final String error;
  const LoginFailed({
    required this.error,
  });
}
