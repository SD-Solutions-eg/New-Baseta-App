import 'dart:convert';

import 'package:allin1/data/models/notification_model.dart';
import 'package:allin1/data/services/notifications_services.dart';

class NotificationRepository {
  final NotificationsServices _notificationsServices;
  NotificationRepository(this._notificationsServices);

  Future<List<NotificationModel>> getNotifications(
      {required int userId}) async {
    try {
      final List<NotificationModel> notifications = [];
      final notificationsJson = await _notificationsServices.getNotifications(
        userId: userId,
      );
      final Map<String, dynamic> notificationsData =
          json.decode(notificationsJson) as Map<String, dynamic>;
      // log(notificationsData.toString());
      for (final element in notificationsData.values) {
        final notificationModel =
            NotificationModel.fromJson(element as Map<String, dynamic>);
        notifications.add(notificationModel);
      }
      return notifications;
    } catch (e) {
      rethrow;
    }
  }
}
