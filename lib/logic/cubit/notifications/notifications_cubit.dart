import 'dart:developer';

import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/data/models/notification_model.dart';
import 'package:allin1/data/repositories/notifications_repository.dart';
import 'package:allin1/data/services/local_notifications.dart';
import 'package:allin1/logic/cubit/internet/internet_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/screens/homeLayout/home_layout.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository notificationRepo;
  final InternetCubit connection;
  NotificationsCubit(
    this.notificationRepo,
    this.connection,
  ) : super(NotificationsInitial()) {
    _getCachedNotificationCount();
    initialize();
  }
  static NotificationsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  int notificationCount = 0;
  List<NotificationModel> notifications = [];

  Future<void> getNotifications() async {
    emit(NotificationsGetLoading());
    final userId = hydratedStorage.read('UID') ?? 1;
    log('userId = $userId');
    if (connection.state is InternetConnectionFail) {
      emit(NotificationsGetFailed(error: LanguageAr().connectionFailed));
    } else {
      try {
        notifications = await notificationRepo.getNotifications(
          userId: userId as int,
        );
        emit(NotificationsGetSuccess());
      } catch (e) {
        emit(NotificationsGetFailed(error: e.toString()));
      }
    }
  }

  Future<void> initialize() async {
    await getUserPermission();
    await initNotifications();
    listenNotification();
    // getInitialMessage();
    foregroundMessage();
  }

  Future<void> getUserPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return;
    }

    settings = await messaging.requestPermission(provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void foregroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');
      log('FirebaseMessaging.onMessage Data: ${message.data}');
      log('Firebase Messaging from : ${message.from}');

      if (message.notification != null) {
        log('FirebaseMessaging.onMessage Title: ${message.notification!.title}');
        log('FirebaseMessaging.onMessage Body: ${message.notification!.body}');
        onNotifications.add(message.data.toString());
        showNotification(
          message.notification?.title ?? 'No title',
          message.notification?.body ?? 'No Body',
          payload: message.data.toString(),
        );
      } else {
        onNotifications.add(message.data.toString());
        showNotification(
          'No Notification title',
          'No Notification Body',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        // HomeLayout.onClickedNotification(context, message.data.toString());
        log('FirebaseMessaging OnMessageOpenedApp');
        if (navKey.currentContext != null) {
          Navigator.of(navKey.currentContext!)
              .pushNamed(AppRouter.notifications);
        }
        // tabController!.animateTo(3, duration: Duration.zero);
      }
    });
  }

  Future<void> getInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null && message.notification != null) {
      log('FirebaseMessaging getInitialMessage ${message.notification}');

      // onNotifications.add(message.data.toString());
      showNotification(
        message.notification!.title!,
        message.notification!.body!,
        payload: message.data.toString(),
      );
    }
  }

  void listenNotification() {
    onNotifications.stream.listen((payload) {
      newNotificationMsg();
    });
  }

  void newNotificationMsg() {
    emit(LocalNotificationsLoading());

    notificationCount++;
    _cacheNotificationCount();
    emit(LocalNotificationsGet());
  }

  void readNotificationMsg() {
    emit(LocalNotificationsLoading());
    notificationCount = 0;
    _cacheNotificationCount();
    emit(LocalNotificationsGet());
  }

  Future<void> _cacheNotificationCount() async {
    await hydratedStorage.write('notificationCount', notificationCount);
  }

  void _getCachedNotificationCount() {
    final count = hydratedStorage.read('notificationCount') as int?;
    if (count != null) {
      notificationCount = count;
    }
  }

  void clearUserData() {
    notificationCount = 0;
    _cacheNotificationCount();
    notifications.clear();
  }
}
