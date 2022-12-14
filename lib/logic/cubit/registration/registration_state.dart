part of 'registration_cubit.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailed extends RegistrationState {
  final String error;
  const RegistrationFailed({
    required this.error,
  });
}
