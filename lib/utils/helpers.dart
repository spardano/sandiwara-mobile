import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/main.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandiwara/models/user_data.dart';

class Helpers {
  showAlertDialog(BuildContext context, String text) {
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Ok"),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Webview App"),
      content: Text(text),
      actions: [okButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  showScafoldMessage(context, String message) async {
    var snackBar = SnackBar(content: Text(message.toString()));
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showLoading(status) {
    return const CircularProgressIndicator();
  }
}

@pragma('vm:entry-point')
Future<void> hendleBackgroundMessage(RemoteMessage message) async {
  print("Title : ${message.notification?.title}");
  print("Body : ${message.notification?.body}");
  print("Payload : ${message.data}");
}

class NotificationArguments {
  final String title;
  final String body;

  NotificationArguments(this.title, this.body);
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  var message;
  switch (notificationResponse.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      message =
          RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
      break;
    case NotificationResponseType.selectedNotificationAction:
      if (notificationResponse.actionId == navigationActionId) {
        message =
            RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
      }
      break;
    default:
  }

  if (message == null) {
    print("Pesan kosong $message");
    return;
  }
  var title = message.notification?.title;
  var body = message.notification?.body;
  var slug = message.data?['slug'];
  try {
    Article article = Article();
    article.getDetailArtikel(FirebaseApi().getContext(), slug);
    print(slug);
  } catch (e) {
    showDialog(
      context: FirebaseApi().getContext()!,
      builder: (context) => customDialog(
        header: 'Gagal',
        text: e.toString(),
        type: 'warning',
      ),
    );
  }
}

class FirebaseApi {
  void getLetter() => print('a and b');
  BuildContext? context;
  final _firebaseMessaging = FirebaseMessaging.instance;

  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    // DarwinNotificationCategory(
    //   darwinNotificationCategoryPlain,
    //   actions: <DarwinNotificationAction>[
    //     DarwinNotificationAction.plain('id_1', 'Action 1'),
    //     DarwinNotificationAction.plain(
    //       'id_2',
    //       'Action 2 (destructive)',
    //       options: <DarwinNotificationActionOption>{
    //         DarwinNotificationActionOption.destructive,
    //       },
    //     ),
    //     DarwinNotificationAction.plain(
    //       navigationActionId,
    //       'Action 3 (foreground)',
    //       options: <DarwinNotificationActionOption>{
    //         DarwinNotificationActionOption.foreground,
    //       },
    //     ),
    //     DarwinNotificationAction.plain(
    //       'id_4',
    //       'Action 4 (auth required)',
    //       options: <DarwinNotificationActionOption>{
    //         DarwinNotificationActionOption.authenticationRequired,
    //       },
    //     ),
    //   ],
    //   options: <DarwinNotificationCategoryOption>{
    //     DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    //   },
    // )
  ];
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', "High Importance Notification",
      description: 'This channel is used for important notification',
      importance: Importance.defaultImportance);

  final _localNotifications = FlutterLocalNotificationsPlugin();
  BuildContext? getContext() {
    return context;
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      print("Pesan kosong $message");
      return;
    }
    var title = message.notification?.title;
    var body = message.notification?.body;
    var slug = message.data?['slug'];
    final notification = message.notification;

    _localNotifications.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: "@mipmap/launcher_icon"),
        ),
        payload: jsonEncode(message.toMap()));
    try {
      Article article = Article();
      article.getDetailArtikel(context, slug);
    } catch (e) {
      showDialog(
        context: this.context!,
        builder: (context) => customDialog(
          header: 'Gagal',
          text: e.toString(),
          type: 'warning',
        ),
      );
    }
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    // const DarwinInitializationSettings initializationSettingsDarwin =
    //     DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // onDidReceiveLocalNotification:
    //     (int id, String? title, String? body, String? payload) async {
    //   didReceiveLocalNotificationStream.add(
    //     ReceivedNotification(
    //       id: id,
    //       title: title,
    //       body: body,
    //       payload: payload,
    //     ),
    //   );
    // },
    // notificationCategories: darwinNotificationCategories,
    // );
    const android = AndroidInitializationSettings("@mipmap/launcher_icon");
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          final message =
              RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
          handleMessage(message);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            final message = RemoteMessage.fromMap(
                jsonDecode(notificationResponse.payload!));
            handleMessage(message);
          }
          break;
        default:
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      print("Pesan on message listen ${message}");
      final notification = message.notification;
      if (notification == null) {
        return;
      }

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: "@mipmap/launcher_icon"),
          ),
          payload: jsonEncode(message.toMap()));
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(hendleBackgroundMessage);
  }

  Future<void> initNotifications(context) async {
    this.context = context;
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('user') && bridge.getString('user') != null) {
      final user =
          jsonDecode(bridge.getString('user')!) as Map<String, dynamic>;

      userData dataUser = userData.fromJson(user);
      if (dataUser.push_notif == 1 || dataUser.push_notif == true) {
        await FirebaseMessaging.instance.subscribeToTopic('SANDIWARA');
      } else {
        log("Unsubscribe");
        await FirebaseMessaging.instance.unsubscribeFromTopic('SANDIWARA');
      }
    } else {
      log("Testing");
      await FirebaseMessaging.instance.subscribeToTopic('SANDIWARA');
    }
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token : $fCMToken');
    initPushNotifications();
    initLocalNotifications();
  }
}
