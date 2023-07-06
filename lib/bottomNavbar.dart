// ignore_for_file: dead_code, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/menu/categoryBerita.dart';
import 'package:sandiwara/menu/homePage.dart';
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
  int currentIndex = 0;
  int _counter = 0;

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return const topBar();
        break;
      case 1:
        return const categoryBerita();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
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
