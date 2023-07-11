import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  var helper = Helpers();
  void signIn(String? email, String? password, context) async {
    try {
      var response = await http.post(Uri.parse('$apiUrl/guest/login'),
          body: {'email': email.toString(), 'password': password.toString()});
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 201) {
        setLoginData(data['access_token'], data['token'], data['id_user']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const bottomNavbar()),
        );
      } else {
        helper.showScafoldMessage(context, data['message']);
      }
    } catch (e) {
      helper.showScafoldMessage(context, e.toString());
    }
  }

  void signUp(String? nama, String? email, String? password, context) async {
    try {
      var response =
          await http.post(Uri.parse('$apiUrl/guest/register'), body: {
        'nama': nama.toString(),
        'email': email.toString(),
        'password': password.toString()
      });

      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 201) {
        setLoginData(data['access_token'], data['token'], data['id_user']);

        var res = jsonDecode(response.body);
        if (res['status'] == false) {
          throw res['message'];
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const bottomNavbar()),
        );
      } else {
        helper.showScafoldMessage(context, data['message']);
      }
    } catch (e) {
      helper.showScafoldMessage(context, e.toString());
    }
  }

  Future<void> setLoginData(
      String access_token, String token, int id_user) async {
    final bridge = await SharedPreferences.getInstance();

    final myData = jsonEncode({
      'access_token': access_token.toString(),
      'token': token.toString(),
      'id_user': id_user.toString()
    });

    if (bridge.containsKey('data_login')) {
      bridge.clear();
    }

    bridge.setString('data_login', myData);
  }

  Future<String?> getToken() async {
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('data_login') &&
        bridge.getString('data_login') != null) {
      final myData =
          jsonDecode(bridge.getString('data_login')!) as Map<String, dynamic>;
      return myData['access_token'];
    }

    return null;
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
}
