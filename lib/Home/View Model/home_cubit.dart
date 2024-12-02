import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late FlutterLocalNotificationsPlugin localNotifications;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<PendingNotificationRequest> pendingNotifications = [];

  List<String>titleList=[];
  List<String>bodyList=[];
  List<String>dateList=[];



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

    fetchPendingNotifications();
    emit(ShowNotificationState());
  }

  Future<void> fetchPendingNotifications() async {
    final notifications =
    await localNotifications.pendingNotificationRequests();

      pendingNotifications = notifications;
emit(FetchPendingNotificationsState());
  }

}
