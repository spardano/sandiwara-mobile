// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/controller/ProfileController.dart';
import 'package:sandiwara/models/userData.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/providers/auth.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key, required this.userDataStorage})
      : super(key: key);

  final userData userDataStorage;
  @override
  State<profilePage> createState() => _profilePageState(userDataStorage);
}

class _profilePageState extends State<profilePage> {
  userData userDataStorage;

  _profilePageState(this.userDataStorage);

  int tapvalue = 0;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontFamily: "Lemon",
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
              color: Colors.black87),
        ),
        elevation: 0.2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15.0,
                          spreadRadius: 0.0)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardProfile(),
                    PanelProfile(
                      userDataStorage: userDataStorage,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15.0,
                          spreadRadius: 0.0)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Aplikasi",
                          style: textStyleTitle.copyWith(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      SizedBox(
                        height: 25.0,
                      ),
                      Line(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Kontak", style: textStyleTitle),
                      SizedBox(
                        height: 20.0,
                      ),
                      Line(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Syarat dan Ketentuan", style: textStyleTitle),
                      SizedBox(
                        height: 20.0,
                      ),
                      Line(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Hapus Akun", style: textStyleTitle),
                      SizedBox(
                        height: 20.0,
                      ),
                      Line(),
                      SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Keluar",
                            style: textStyleTitle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Provider.of<Auth>(context, listen: false)
                                    .clearDataLogin(context);
                              }),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PanelProfile extends StatefulWidget {
  final userData userDataStorage;

  const PanelProfile({Key? key, required this.userDataStorage})
      : super(key: key);

  @override
  State<PanelProfile> createState() => _PanelProfileState(userDataStorage);
}

class _PanelProfileState extends State<PanelProfile> {
  userData? userDataStorage;
  bool switch2 = false;
  ProfileController profileController = Get.put(ProfileController());

  _PanelProfileState(this.userDataStorage);

  bool _switch1 = false;
  bool _switch2 = false;
  int tapvalue = 0;

  @override
  void initState() {
    super.initState();
    _switch1 = userDataStorage!.push_notif == 1 ? true : false;
    _switch2 = userDataStorage!.email_news_sub == 1 ? true : false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "General",
            style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w600,
                fontFamily: "Popins"),
          ),
          SizedBox(
            height: 15.0,
          ),
          Line(),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Ganti Password",
            style: textStyleTitle,
          ),
          SizedBox(
            height: 15.0,
          ),
          Line(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Notifikasi", style: textStyleTitle),
              Switch(
                value: _switch1,
                onChanged: (bool e) => {
                  setState(() {
                    if (e) {
                      e = true;
                      _switch1 = true;
                    } else {
                      e = false;
                      _switch1 = false;
                    }
                  })
                },
                activeColor: Colors.lightBlueAccent,
                inactiveTrackColor: Colors.black12,
              ),
            ],
          ),
          Text(
              "Kamu bisa mengontrol apakah kamu bersedia menerima pemberitahuan mengenai berita terkini dengan mengaktifkan notifikasi",
              style: textStyleDeskripsi),
          SizedBox(
            height: 15.0,
          ),
          Line(),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      width: double.infinity,
      color: Colors.black12.withOpacity(0.03),
    );
  }
}

class CardProfile extends StatelessWidget {
  const CardProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 180.0,
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 198, 35, 35),
                Color.fromARGB(255, 226, 152, 33)
              ])),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://images.pexels.com/photos/3541390/pexels-photo-3541390.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Text(
                  "Jipau Developer",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                      color: Colors.white,
                      letterSpacing: 1.5),
                ),
                const Text(
                  "Jipaudev@gmail.com",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontFamily: "Sans",
                      fontSize: 14.0),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
