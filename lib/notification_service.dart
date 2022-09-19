
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class NotificationService {
  // static final NotificationService _notificationService =
  //     NotificationService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // factory NotificationService() {
  //   return _notificationService;
  // }


final BehaviorSubject<String?> onClickNotification = BehaviorSubject();


  void init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');



     IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );


    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
           );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification
    );

  }


  Future<NotificationDetails> _notificationDetails() async{
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
        "channelId",
        "channel_name",
        channelDescription: 'This is a dummy message',
        priority: Priority.high,
        importance: Importance.max,
      icon:'@mipmap/ic_launcher',
      channelShowBadge: true,
      playSound: true


    );

    IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails();

    return NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

  }

  Future<void> showNotification({
   required int id,
   required String? title,
   required String? body,
})async{
    final details = await _notificationDetails();
    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }
  void onDidReceiveLocalNotification(int id,String? title, String? body, String? payload ){
    print('id $id');
  }


  Future<void> showScheduleNotification({
    required int id,
    required String? title,
    required String? body,
    required int seconds,
  })async{
    final details = await _notificationDetails();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(DateTime.now().add(Duration(seconds: seconds)),tz.local,),
        details,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showNotificationPayload({
    required int id,
    required String? title,
    required String? body,
    required String payload
  })async{
    final details = await _notificationDetails();
    await flutterLocalNotificationsPlugin.show(id, title, body, details, payload: payload);
  }


  
  void onSelectNotification(String? payload) {
    print('payload $payload');

    if(payload != null && payload.isNotEmpty){
      onClickNotification.add(payload);
    }
  }
}






