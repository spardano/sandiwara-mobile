import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/inside/profilePage.dart';
import 'package:sandiwara/models/userData.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  void signIn(String? email, String? password, context) async {
    try {
      var response = await http.post(Uri.parse(apiUrl + '/guest/login'),
          body: {'email': email.toString(), 'password': password.toString()});

      var data = jsonDecode(response.body.toString());

      if (data['status'] == true) {
        userData user_data = userData.fromJson(data['user']);

        setLoginData(
            data['access_token'], data['token'], data['id_user'], user_data);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bottomNavbar()),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) => customDialog(
                  header: 'Gagal',
                  text: data['message'],
                  type: 'warning',
                ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void signUp(String? nama, String? email, String? password, context) async {
    Uri url = Uri.parse(apiUrl + '/guest/register');

    try {
      var response =
          await http.post(Uri.parse(apiUrl + '/guest/register'), body: {
        'nama': nama.toString(),
        'email': email.toString(),
        'password': password.toString()
      });

      var data = jsonDecode(response.body.toString());
      userData user_data = userData.fromJson(data['user']);

      print(data['access_token']);
      setLoginData(
          data['access_token'], data['token'], data['id_user'], user_data);

      var res = jsonDecode(response.body);

      if (data['status']) {
        if (res['status'] == false) {
          throw res['message'];
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bottomNavbar()),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) => customDialog(
                  header: 'Gagal',
                  text: res['message'],
                  type: 'warning',
                ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setLoginData(
      String access_token, String token, int id_user, userData user) async {
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('access_token')) {
      bridge.remove('access_token');
    }

    if (bridge.containsKey('user')) {
      bridge.remove('user');
    }

    bridge.setString('access_token', access_token.toString());
    bridge.setString('user', userData.encode(user));
  }

  Future<void> clearDataLogin(context) async {
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('data_login')) {
      bridge.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => bottomNavbar()),
      );
    }
  }

  void getUser(context) async {
    try {
      final bridge = await SharedPreferences.getInstance();

      if (bridge.containsKey('user') && bridge.getString('user') != null) {
        final user =
            jsonDecode(bridge.getString('user')!) as Map<String, dynamic>;

        final userData user_data = userData.fromJson(user);

        if (user_data != null) {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => profilePage(
                      userDataStorage: user_data,
                    ),
                transitionDuration: Duration(milliseconds: 600),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
