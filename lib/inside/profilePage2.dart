import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/controller/ProfileController.dart';
import 'package:sandiwara/inside/profilePage.dart';
import 'package:sandiwara/models/user_data.dart';

class profilePage2 extends StatefulWidget {
  const profilePage2({Key? key, required this.userDataStorage})
      : super(key: key);
  final userData userDataStorage;
  @override
  State<profilePage2> createState() => _profilePage2State();
}

class _profilePage2State extends State<profilePage2> {
  ProfileController profileController = Get.put(ProfileController());

  bool _switch1 = false;
  bool _switch2 = false;
  int tapvalue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _switch1 = widget.userDataStorage.push_notif == 1 ? true : false;
    _switch2 = widget.userDataStorage!.email_news_subs == 1 ? true : false;
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
                    CardProfile(
                      email: 'Ridho Al Amzah',
                      nama: 'ralamzah@gmail.com',
                    ),
                    PanelProfile(),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notifikasi",
                                style: textStyleTitle,
                              ),
                              Switch(
                                  value: _switch1,
                                  onChanged: (e) {
                                    if (e) {
                                      e = true;
                                      _switch1 = true;
                                    } else {
                                      e = false;
                                      _switch1 = false;
                                    }
                                    setState(() {});
                                  })
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

class PanelProfile extends StatefulWidget {
  const PanelProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<PanelProfile> createState() => _PanelProfileState();
}

class _PanelProfileState extends State<PanelProfile> {
  bool switch2 = false;
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
                value: switch2,
                onChanged: (bool e) => setState(() {
                  if (e) {
                    e = true;
                    switch2 = true;
                  } else {
                    e = false;
                    switch2 = false;
                  }
                }),
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
