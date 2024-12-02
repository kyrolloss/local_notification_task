import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String body;

  const NotificationWidget(
      {super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xffF5F5DC),
            child: Icon(
              Icons.notifications_active_rounded,
              color: Color(0xff000080),
            ),
          ),
          SizedBox(
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
                    color: const Color(0xffF5F5DC)),
              ),
              Text(
                body,

                style: TextStyle(
                    fontSize: 12,

                    fontWeight: FontWeight.bold,
                    color: const Color(0xffF5F5DC).withOpacity(.75)),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
