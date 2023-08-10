// ignore_for_file: dead_code, camel_case_types

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/menu/categoryBerita.dart';
import 'package:sandiwara/menu/homePage.dart';
import 'package:sandiwara/menu/searchBerita.dart';
import 'package:sandiwara/topBar.dart';

class bottomNavbar extends StatefulWidget {
  const bottomNavbar({super.key, this.notificationAppLaunchDetails});
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationAppLaunchDetails =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  @override
  State<bottomNavbar> createState() => _bottomNavbarState();
}

class _bottomNavbarState extends State<bottomNavbar> {
  String? mtoken = "";
  int currentIndex = 0;
  int _counter = 0;

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return const topBar();
        break;
      case 1:
        return const categoryBerita();
      case 2:
        return const searchBerita();
      default:
        return const homePage();
    }
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationPlugin.show(
      0,
      "Testing $_counter",
      "How you do in ?",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          color: Colors.blue,
          icon: '@drawable/splash',
        ),
      ),
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted Provisional Permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("my token is $mtoken");
      });
    });
  }

  initInfo() {
    FirebaseMessaging.instance.subscribeToTopic("SANDIWARA");

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    var androidInitilize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSInitialize);
    flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotification:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    // flutterLocalNotificationPlugin.initialize(initializationSettings,
    //     onDidReceiveNotificationResponse:
    //         (NotificationResponse notificationResponse) {
    //   switch (notificationResponse.notificationResponseType) {
    //     case NotificationResponseType.selectedNotification:
    //       selectNotificationStream.add(notificationResponse.payload);
    //       break;
    //     case NotificationResponseType.selectedNotification:
    //       if (notificationResponse.actionId == navigationActionId) {
    //         selectNotificationStream.add(notificationResponse.payload);
    //       }
    //   }
    // }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    // FirebaseMessaging.onMessage.listen(
    //   (RemoteMessage message) {
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       flutterLocalNotificationPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             playSound: true,
    //             icon: "@drawable/splash",
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );

    // await FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published !');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     showDialog(
    //       context: context,
    //       builder: (_) {
    //         return AlertDialog(
    //           title: Text(notification.title.toString()),
    //           content: SingleChildScrollView(
    //               child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 notification.body.toString(),
    //               ),
    //             ],
    //           )),
    //         );
    //       },
    //     );
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    // getToken();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // showNotification();
      //     showDialog(
      //         context: context,
      //         builder: (context) => customDialog(
      //               header: 'Berhasil',
      //               text: 'Ini adalah testing',
      //               type: 'success',
      //             ));
      //   },
      //   child: const Icon(Icons.message),
      // ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(
                  color: Colors.black26.withOpacity(0.15),
                ),
              ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          fixedColor: Colors.red[600],
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 23.0,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.grid_3x3,
                ),
                label: "Kategori"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Pencarian"),
          ],
        ),
      ),
    );
  }
}
