part of 'google_cubit.dart';

abstract class GoogleState extends Equatable {
  const GoogleState();

  @override
  List<Object> get props => [];
}

class GoogleInitial extends GoogleState {}

class GoogleLoading extends GoogleState {}

class GoogleSuccess extends GoogleState {}

class GoogleCancelled extends GoogleState {}

class GoogleFailed extends GoogleState {
  final String error;
  const GoogleFailed({
    required this.error,
  });
}
