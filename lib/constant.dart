import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String apiUrl = 'http://192.168.100.38:8000/api';
const String mainUrl = 'http://192.168.100.38:8000';
// const String apiUrl = 'https://sandiwara.id/api';
// const String mainUrl = 'https://sandiwara.id';

InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  crossPlatform: InAppWebViewOptions(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
  ),
  android: AndroidInAppWebViewOptions(
    useHybridComposition: true,
  ),
  ios: IOSInAppWebViewOptions(
    allowsInlineMediaPlayback: true,
  ),
);

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const String urlLaunchActionId = 'id_1';

const String navigationActionId = 'id_3';

String? selectedNotificationPayload;

const String darwinNotificationCategoryText = 'textCategory';
const String darwinNotificationCategoryPlain = 'plainCategory';

void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_imortance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

const textStyleTitle = TextStyle(
    color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 15.0);

const textStyleDeskripsi =
    TextStyle(color: Colors.black26, fontWeight: FontWeight.w400);
