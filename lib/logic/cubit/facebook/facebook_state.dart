part of 'facebook_cubit.dart';

abstract class FacebookState extends Equatable {
  const FacebookState();

  @override
  List<Object> get props => [];
}

class FacebookInitial extends FacebookState {}

class FacebookLoading extends FacebookState {}

class FacebookSuccess extends FacebookState {}

class FacebookFailed extends FacebookState {
  final String error;
  const FacebookFailed({
    required this.error,
  });
}
