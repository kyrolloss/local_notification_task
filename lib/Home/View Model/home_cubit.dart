import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  DateTime? selectedDate;

  var controller01 = ValueNotifier<bool>(false);
  var controller02 = ValueNotifier<bool>(false);
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<PendingNotificationRequest> pendingNotifications = [];

  List<String> titleList = [];
  List<String> bodyList = [];
  List<int> idList = [];


  void pickDate({required BuildContext context}) async {
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
        selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
      }
    }
    emit(PickTimeState());
  }

  void changeSwitcher(
      {required ValueNotifier controller, required bool value}) {
    if (controller.value == true) {
      controller.value = !value;
      selectedDate = null;
    }
    emit(ChangeSwitcher());
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
    emit(RequestPermissionState());
  }

  void printLocalTime() {
    final now = DateTime.now();
    final localTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
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
    titleList.add(title);
    bodyList.add(body);
    idList.add(DateTime.now().millisecond.toInt());

    fetchPendingNotifications();
    emit(ShowNotificationState());
  }

  Future<void> scheduleNotification(String title, String body) async {
    if (selectedDate == null) {
      return;
    }

    final egyptLocation = tz.getLocation('Africa/Cairo');
    final scheduledDateInEgypt =
        tz.TZDateTime.from(selectedDate!, egyptLocation);

    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);
    print("Notification ID: $notificationId");

    try {
      final tz.TZDateTime scheduledDate =
          tz.TZDateTime.from(selectedDate!, tz.local);
      await localNotifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDateInEgypt,
        platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      titleList.add(title);
      bodyList.add(body);
      idList.add(notificationId);
      print(idList);

      emit(SetScheduledNotificationsState());
      fetchPendingNotifications();
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  Future<void> fetchPendingNotifications() async {
    final notifications =
        await localNotifications.pendingNotificationRequests();

    pendingNotifications = notifications;
    emit(FetchPendingNotificationsState());
  }


  Future<void> clearNotifications(int id) async {
    await localNotifications.cancel(id).then((_){
      List <int> result = [];
      for(var i in idList){
        if (i != id ){
          result.add(i);

        }

        idList = result;
      }
    });
    emit(SetScheduledNotificationsState());

    fetchPendingNotifications();

  }
}
