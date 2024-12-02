import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

import 'Home/View Model/home_cubit.dart';
import 'Home/View/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(),
        child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Notifications Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomePage(),
        ));
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late FlutterLocalNotificationsPlugin localNotifications;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  DateTime? selectedDate;

  List<PendingNotificationRequest> pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    tzData.initializeTimeZones();

    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    localNotifications = FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initSettings);

    requestPermission();
    fetchPendingNotifications();
  }

  Future<void> requestPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      debugPrint("Notifications permission granted");
    } else {
      debugPrint("Notifications permission denied");
    }
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
    );
    fetchPendingNotifications();
  }

  Future<void> scheduleNotification(String title, String body) async {
    if (selectedDate == null) return;

    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await localNotifications.zonedSchedule(
      DateTime.now().millisecond,
      title,
      body,
      tz.TZDateTime.from(selectedDate!, tz.local),
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    fetchPendingNotifications(); // تحديث القائمة بعد جدولة الإشعار
  }

  Future<void> clearAllNotifications() async {
    await localNotifications.cancelAll();
    fetchPendingNotifications(); // تحديث القائمة بعد حذف كل الإشعارات
  }

  Future<void> fetchPendingNotifications() async {
    final notifications =
        await localNotifications.pendingNotificationRequests();
    setState(() {
      pendingNotifications = notifications;
    });
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked != null) {
        setState(() {
          selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    bodyController.text.isNotEmpty) {
                  if (selectedDate != null) {
                    scheduleNotification(
                        titleController.text, bodyController.text);
                  } else {
                    showNotification(titleController.text, bodyController.text);
                  }
                }
              },
              child: Text(selectedDate == null
                  ? 'Send Notification Instantly'
                  : 'Schedule Notification'),
            ),
            ElevatedButton(
              onPressed: clearAllNotifications,
              child: const Text('Clear All Notifications'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickDate,
              child: const Text('Pick Date & Time'),
            ),
            const SizedBox(height: 20),
            pendingNotifications.isEmpty
                ? const Text('No pending notifications.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: pendingNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = pendingNotifications[index];
                        return ListTile(
                          title: Text(notification.title ?? 'No title'),
                          subtitle: Text(notification.body ?? 'No body'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await localNotifications
                                  .cancel(notification.id); // حذف الإشعار
                              fetchPendingNotifications(); // تحديث القائمة
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
