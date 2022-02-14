import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz2;
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
    final android = AndroidInitializationSettings('@mipmap/launcher_icon');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _alert.initialize(settings, onSelectNotification: (playload) async {
      onNotifications.add(playload);
    });

    if (initScheluded) {
      tz2.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showAlert({
    required int id,
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
        //_schuledDaily(Time(8)),
        await _alertDetails(),
        payload: playLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  // static tz.TZDateTime _schuledDaily(Time time) {
  //   final now = DateTime.now();
  //   final schuledDate = tz.TZDateTime(
  //     tz.local,
  //     now.year,
  //     now.month,
  //     now.day,
  //     time.hour,
  //     time.minute,
  //     time.second,
  //   );

  //   return schuledDate.isBefore(now) ? schuledDate.add(Duration(days: 1)) : schuledDate;
  // }
}
