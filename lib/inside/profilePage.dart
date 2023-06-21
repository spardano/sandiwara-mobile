// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/providers/auth.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  bool _switch1 = false;
  bool _switch2 = false;
  int tapvalue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),

      ///
      /// Appbar
      ///
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
            ///
            /// This is card box for profile
            ///
            _cardProfile(),
            const SizedBox(
              height: 10.0,
            ),

            _cardAnother()
          ],
        ),
      ),
    );
  }

  var _txtStyleTitle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 15.0);

  var _txtStyleDeskripsi =
      TextStyle(color: Colors.black26, fontWeight: FontWeight.w400);

  Widget _cardProfile() {
    return Padding(
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
            Stack(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
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
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
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
                  _line(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Ganti Password",
                    style: _txtStyleTitle,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _line(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Notifikasi", style: _txtStyleTitle),
                      Switch(
                        value: _switch2,
                        onChanged: (bool e) => _something2(e),
                        activeColor: Colors.lightBlueAccent,
                        inactiveTrackColor: Colors.black12,
                      ),
                    ],
                  ),
                  Text(
                      "Kamu bisa mengontrol apakah kamu bersedia menerima pemberitahuan mengenai berita terkini dengan mengaktifkan notifikasi",
                      style: _txtStyleDeskripsi),
                  SizedBox(
                    height: 15.0,
                  ),
                  _line(),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAnother() {
    return Padding(
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
                  style: _txtStyleTitle.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              SizedBox(
                height: 25.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Kontak", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Syarat dan Ketentuan", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Hapus Akun", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                    text: "Keluar",
                    style: _txtStyleTitle,
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
    );
  }

  Widget _line() {
    return Container(
      height: 1.5,
      width: double.infinity,
      color: Colors.black12.withOpacity(0.03),
    );
  }

  ///
  /// void for radio button finger print
  ///
  void _something(bool e) {
    setState(() {
      if (e) {
        e = true;
        _switch1 = true;
      } else {
        e = false;
        _switch1 = false;
      }
    });
  }

  ///
  /// void for radio button notifications
  ///
  void _something2(bool e) {
    setState(() {
      if (e) {
        e = true;
        _switch2 = true;
      } else {
        e = false;
        _switch2 = false;
      }
    });
  }
}
