// ignore_for_file: camel_case_types, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/menu/homePage.dart';
import 'package:sandiwara/inside/profilePage.dart';
import 'package:sandiwara/pages/loginPage.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:sandiwara/topMenu/terkiniPage.dart';
import 'package:sandiwara/topMenu/trendingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class topBar extends StatefulWidget {
  const topBar({super.key});

  @override
  State<topBar> createState() => _topBarState();
}

class _topBarState extends State<topBar> {
  bool isAuthenticated = false;
  String? token = null;

  Future<void> getToken() async {
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('data_login') &&
        bridge.getString('data_login') != null) {
      final myData =
          jsonDecode(bridge.getString('data_login')!) as Map<String, dynamic>;

      if (myData['access_token'] != null) {
        isAuthenticated = true;
        token = myData['access_token'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getToken(),
        builder: (context, _) => DefaultTabController(
              length: 3,
              child: Scaffold(
                  backgroundColor: const Color(0xFFF9F9F9),
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flexible(
                            flex: 3,
                            child: Image.asset(
                              "assets/images/logo_sandiwara.png",
                              width: 140,
                            ),
                          ),
                        ),
                      ],
                    ),
                    elevation: 0.2,
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            if (isAuthenticated == false) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => profilePage()),
                              );
                            }
                          },
                          child: isAuthenticated == false
                              ? const Icon(Icons.login,
                                  color: Colors.black54, size: 19.0)
                              : const Icon(
                                  Icons.person_outline,
                                  color: Color.fromARGB(255, 206, 145, 4),
                                  size: 22.0,
                                ),
                        ),
                      ),
                    ],
                    bottom: TabBar(
                        labelColor: Colors.redAccent,
                        unselectedLabelColor: Colors.black12.withOpacity(0.5),
                        indicatorColor: Colors.redAccent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 2.5,
                        tabs: const [
                          Tab(
                            child: Text('Beranda'),
                          ),
                          Tab(
                            child: Text('Terpopuler'),
                          ),
                          Tab(
                            child: Text('Terbaru'),
                          ),
                        ]),
                  ),
                  body: const TabBarView(
                    children: <Widget>[
                      homePage(),
                      trendingPage(),
                      terkiniPage(),
                    ],
                  )),
            ));
  }
}
