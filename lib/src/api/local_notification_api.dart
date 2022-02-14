import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationApi {
  static final _alert = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static _alertDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'chanel id',
        'chanel name',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheluded = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _alert.initialize(settings, onSelectNotification: (playload) async {
      onNotifications.add(playload);
    });
  }

  static Future showAlert({
    int id = 0,
    String? title,
    String? body,
    String? playLoad,
  }) async =>
      _alert.show(id, title, body, await _alertDetails(), payload: playLoad);

  static Future showAlertProgramado({
    int id = 0,
    String? title,
    String? body,
    String? playLoad,
    required DateTime time,
  }) async =>
      _alert.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time, tz.local),
        await _alertDetails(),
        payload: playLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
}
