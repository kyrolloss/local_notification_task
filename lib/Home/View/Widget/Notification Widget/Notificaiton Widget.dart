import 'package:flutter/material.dart';
import 'package:local_notification_task/Home/View%20Model/home_cubit.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String body;
  final bool isPending;
  final int? index;

  final Color? titleColor;
  final Color? bodyColor;

  const NotificationWidget(
      {super.key,
      required this.title,
      required this.body,
      this.titleColor,
      this.bodyColor,
      this.isPending = true,
      this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xffF5F5DC),
            child: Icon(
              Icons.notifications_active_rounded,
              color: Color(0xff000080),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? const Color(0xffF5F5DC)),
              ),
              Text(
                body,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        bodyColor ?? const Color(0xffF5F5DC).withOpacity(.75)),
              ),
            ],
          ),
          const Spacer(),
          isPending == false
              ? IconButton(
                  onPressed: () {
                    HomeCubit.get(context).titleList.removeAt(index!);
                    HomeCubit.get(context).bodyList.removeAt(index!);
                    HomeCubit.get(context).clearNotifications(
                        HomeCubit.get(context).idList[index!]);


                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}
