part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

class InternetInitial extends InternetState {}

class InternetConnectionSuccess extends InternetState {}

class InternetConnectionFail extends InternetState {}
