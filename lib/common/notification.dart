import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{
  static final notification = FlutterLocalNotificationsPlugin();

  static Future notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel title',
        importance: Importance.max
      )
    );
  }
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
}) async => notification.show(id, title, body, await notificationDetails());
}