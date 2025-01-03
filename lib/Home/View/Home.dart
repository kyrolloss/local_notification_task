import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_task/Home/View%20Model/home_cubit.dart';
import 'package:local_notification_task/Home/View/Widget/Notification%20Widget/Notificaiton%20Widget.dart';
import 'package:local_notification_task/Home/View/Widget/Pending%20Notification%20Dialog/Pending%20Notification%20Dialog.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    tzData.initializeTimeZones();

    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    HomeCubit.get(context).localNotifications.initialize(initSettings);
    _bodyController = TextEditingController();
    _titleController = TextEditingController();
    HomeCubit.get(context).requestPermission();
    HomeCubit.get(context).fetchPendingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:  AppBar(backgroundColor: Colors.black,
        title: const Text('Notifications' , style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context, builder: (context) => const Dialog(
              child: PendingNotificationDialog(),
            ),);
          }, icon: const Icon(Icons.pending_actions , color: Colors.white,)),
        ],

      ),
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Colors.black,
                Color(0xff000080),
              ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: GradientRotation(2 / 8))),
          child: SingleChildScrollView(
            child: Column(
              children: [
            
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffF5F5DC),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter the title',
                            filled: true,
                            fillColor: const Color(0xffF5F5DC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xff000080),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Body',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffF5F5DC),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _bodyController,
                          decoration: InputDecoration(
                            hintText: 'Enter the body',
                            filled: true,
                            fillColor: const Color(0xffF5F5DC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.teal,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instant Notifications',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            BlocConsumer<HomeCubit, HomeState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                return Text(
                                  'Push instant Notification',
                                  style: TextStyle(
                                      color: HomeCubit.get(context)
                                                  .controller01
                                                  .value ==
                                              true
                                          ? Colors.white60
                                          : Colors.white30,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ],
                        ),
                        BlocConsumer<HomeCubit, HomeState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return AdvancedSwitch(
                              width: width * .15,
                              height: height * .04,
                              controller: HomeCubit.get(context).controller01,
                              onChanged: (value) {
                                HomeCubit.get(context).changeSwitcher(
                                    controller:
                                        HomeCubit.get(context).controller02,
                                    value: value);
                              },
                            );
                          },
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Schedule Notifications',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            BlocConsumer<HomeCubit, HomeState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                return Text(
                                  'Push schedule Notification',
                                  style: TextStyle(
                                      color: HomeCubit.get(context)
                                                  .controller02
                                                  .value ==
                                              true
                                          ? Colors.white60
                                          : Colors.white30,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ],
                        ),
                        BlocConsumer<HomeCubit, HomeState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return AdvancedSwitch(
                              width: width * .15,
                              height: height * .04,
                              controller: HomeCubit.get(context).controller02,
                              onChanged: (value) {
                                HomeCubit.get(context).changeSwitcher(
                                    controller:
                                        HomeCubit.get(context).controller01,
                                    value: value);
                              },
                            );
                          },
                        ),
                      ]),
                ),
                BlocConsumer<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return HomeCubit.get(context).controller02.value
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Set Time',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Set Time for schedule Notification',
                                        style: TextStyle(
                                            color: Colors.white30,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      HomeCubit.get(context)
                                          .pickDate(context: context);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        child: Center(
                                          child: Text(
                                              HomeCubit.get(context)
                                                          .selectedDate ==
                                                      null
                                                  ? 'Pick Time'
                                                  : '${HomeCubit.get(context).selectedDate!.hour}:${HomeCubit.get(context).selectedDate!.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                        )),
                                  )
                                ]),
                          )
                        : const SizedBox();
                  },
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                ),
                InkWell(
                  onTap: () {
                    if (HomeCubit.get(context).controller01.value == true) {
                      HomeCubit.get(context).showNotification(
                          _titleController.text, _bodyController.text);
                    } else if (HomeCubit.get(context).controller02.value ==
                        true) {
                      HomeCubit.get(context).scheduleNotification(
                          _titleController.text, _bodyController.text);
                    }
                    _titleController.clear();
                    _bodyController.clear();
                  },
                  child: Container(
                      height: height * .055,
                      width: width * .7,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color(0xffF5F5DC),
                          borderRadius: BorderRadius.circular(18)),
                      child: const Center(
                        child: Text('Push Notification',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      )),
                ),
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: HomeCubit.get(context).titleList.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => NotificationWidget(
                        isPending:false,
                        index: index,
                        title: HomeCubit.get(context).titleList[index],
                        body: HomeCubit.get(context).bodyList[index],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
