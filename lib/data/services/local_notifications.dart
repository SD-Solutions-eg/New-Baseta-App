import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final _notificationPlugin = FlutterLocalNotificationsPlugin();
final onNotifications = BehaviorSubject<String?>();
const channel = AndroidNotificationChannel(
  "ETagerChannel",
  "ETager Channel Name",
  importance: Importance.max,
);

Future<void> initNotifications() async {
  await createNotificationChannel();

  final details = await _notificationPlugin.getNotificationAppLaunchDetails();
  if (details != null && details.didNotificationLaunchApp) {}

  await _notificationPlugin.initialize(
    _initializationSettings(),
    onSelectNotification: (payload) async {
      return _onSelectNotification(payload);
    },
  );
}

Future<void> _onSelectNotification(String? payload) async {
  if (navKey.currentContext != null) {
    Navigator.of(navKey.currentContext!).pushNamed(AppRouter.orders);
  }
}

Future<void> createNotificationChannel() async {
  await _notificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> showNotification(
  String title,
  String body, {
  String? payload,
}) async {
  final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  _notificationPlugin.show(
    id,
    title,
    body,
    _notificationDetails(),
    payload: payload,
  );
}

NotificationDetails _notificationDetails() {
  final androidNotificationDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    importance: Importance.max,
  );
  return NotificationDetails(
    android: androidNotificationDetails,
    iOS: const IOSNotificationDetails(),
  );
}

InitializationSettings _initializationSettings() {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  return const InitializationSettings(
    android: androidSettings,
    iOS: IOSInitializationSettings(),
  );
}
