import 'package:flutter/material.dart';
import 'package:local_notification_task/Home/View%20Model/home_cubit.dart';
import 'package:local_notification_task/Home/View/Widget/Notification%20Widget/Notificaiton%20Widget.dart';

class PendingNotificationDialog extends StatelessWidget {
  const PendingNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      height: height * .7,
      padding: EdgeInsets.all(2.5),
      width: width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          SizedBox(height: height * .02),
          const Text(
            'Pending Notification',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          
          SizedBox(height: height * .02),
          Expanded(
              child: ListView.builder(
                itemCount: HomeCubit
                    .get(context)
                    .pendingNotifications!
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return NotificationWidget(title: HomeCubit
                      .get(context)
                      .pendingNotifications[index].title!, body: HomeCubit
                      .get(context)
                      .pendingNotifications[index].body! ,bodyColor: Colors.black , titleColor: Colors.black,);
                },
              ))
        ],
      ),
    );
  }
}
