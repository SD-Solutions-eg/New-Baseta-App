part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class LocalNotificationsLoading extends NotificationsState {}

class LocalNotificationsGet extends NotificationsState {}

class NotificationsGetLoading extends NotificationsState {}

class NotificationsGetSuccess extends NotificationsState {}

class NotificationsGetFailed extends NotificationsState {
  final String error;
  const NotificationsGetFailed({
    required this.error,
  });
}
