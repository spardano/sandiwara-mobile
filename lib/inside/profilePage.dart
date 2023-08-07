// ignore_for_file: prefer_const_constructors, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/controller/ProfileController.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/models/user_data.dart';
import 'package:sandiwara/pages/change_password.dart';
import 'package:sandiwara/providers/auth.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key, required this.userDataStorage})
      : super(key: key);

  final userData userDataStorage;
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  int tapvalue = 0;

  @override
  void initState() {
    super.initState();
  }

  hapusAkun() {
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Apakah kamu yakin ingin menghapus akun ?"),
      icon: Icon(
        Icons.alarm,
        color: Colors.black,
      ),
      iconPadding: EdgeInsets.only(top: 10, bottom: 10),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<Auth>(context, listen: false).deleteAccount(context);
          },
          child: Text(
            "Ya",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Batal",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), 
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
                    CardProfile(
                      email: widget.userDataStorage.email.toString(),
                      nama: widget.userDataStorage.name.toString(),
                    ),
                    PanelProfile(
                      userDataStorage: widget.userDataStorage,
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
                      TextButtonCustom(
                        text: "Hapus Akun",
                        onPress: hapusAkun,
                      ),
                      Line(),
                      TextButtonCustom(
                          onPress: () {
                            Provider.of<Auth>(context, listen: false)
                                .clearDataLogin(context);
                          },
                          text: "Keluar"),
                      SizedBox(
                        height: 10.0,
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

class TextButtonCustom extends StatelessWidget {
  const TextButtonCustom({
    Key? key,
    required this.onPress,
    required this.text,
  }) : super(key: key);
  final VoidCallback onPress;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.all(0), alignment: Alignment.centerLeft),
      onPressed: onPress,
      child: Text(
        text,
        style: textStyleTitle,
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
          TextButtonCustom(
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ChangePassword(),
                ));
              },
              text: "Ganti Password"),
          Line(),
          UpdateNotification(
              action: (e) {
                if (e) {
                  e = true;
                  _switch1 = true;
                } else {
                  e = false;
                  _switch1 = false;
                }
                profileController.updateNotificationStatus(
                    _switch1, 'push-notif');
                setState(() {});
              },
              title: "Notification",
              desc:
                  "Kamu bisa mengontrol apakah kamu bersedia menerima pemberitahuan mengenai berita terkini dengan mangaktifkan notifikasi",
              status: _switch1),
          UpdateNotification(
              action: (e) {
                if (e) {
                  e = true;
                  _switch2 = true;
                } else {
                  e = false;
                  _switch2 = false;
                }
                profileController.updateNotificationStatus(
                    _switch2, 'email-sub');
                setState(() {});
              },
              title: "Langganan Email",
              desc:
                  "Kamu bisa mengontrol apakah kamu bersedia menerima pemberitahuan ke email secara berkala ke email kamu",
              status: _switch2),
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

class UpdateNotification extends StatelessWidget {
  const UpdateNotification({
    Key? key,
    required this.title,
    required this.desc,
    required this.action,
    required this.status,
  }) : super(key: key);
  final String title;
  final String desc;
  final Function(bool) action;
  final bool status;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: textStyleTitle),
            Switch(
              value: status,
              onChanged: action,
              activeColor: Colors.lightBlueAccent,
              inactiveTrackColor: Colors.black12,
            ),
          ],
        ),
        Text(desc, style: textStyleDeskripsi),
      ],
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
    required this.nama,
    required this.email,
  }) : super(key: key);
  final String nama;
  final String email;
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
                        image: AssetImage("assets/images/avatar.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  nama ?? "Jipau Developer",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Popins",
                      color: Colors.white,
                      letterSpacing: 1.5),
                ),
                Text(
                  email ?? "Jipaudev@gmail.com",
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
