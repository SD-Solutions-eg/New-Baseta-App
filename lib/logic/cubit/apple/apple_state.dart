part of 'apple_cubit.dart';

abstract class AppleState extends Equatable {
  const AppleState();

  @override
  List<Object> get props => [];
}

class AppleInitial extends AppleState {}

class AppleSignInLoading extends AppleState {}

class AppleSignInSuccess extends AppleState {}

class AppleSignInCancelled extends AppleState {}

class AppleSignInFailed extends AppleState {
  final String error;
  const AppleSignInFailed({
    required this.error,
  });
}
