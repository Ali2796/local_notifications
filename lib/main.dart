import 'package:flutter/material.dart';
import 'package:local_notifications/chat_section.dart';

import 'notification_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  runApp(const MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var id = 0;
   final NotificationService service = NotificationService() ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenToNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () async{
            await service.showNotification(id: id, title: 'notificationTitle', body: 'Hello budy');
            id++;
          }, child: const Text('show local  notification'),),
          ElevatedButton(onPressed: () async{
            await service.showScheduleNotification(id: id, title: 'notificationTitle', body: 'Hello budy',seconds: 2);
            id++;
          }, child: const Text('show local schedule notification'),),
          ElevatedButton(onPressed: () async{
            await service.showNotificationPayload(id: id, title: 'notificationTitle', body: 'Hello budy',payload: 'payload navigation');
            id++;
          }, child: const Text('show local payload notification'),),
        ],
      ),
    );
  }
  void listenToNotification() => service.onClickNotification.stream.listen(onNotificationListner);

  void onNotificationListner(String? payload) {
    if(payload != null && payload.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>const ChatSection(),));

    }
  }
}
