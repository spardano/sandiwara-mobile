import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/inside/profilePage.dart';
import 'package:sandiwara/inside/profilePage2.dart';
import 'package:sandiwara/models/user_data.dart';
import 'package:sandiwara/pages/loginPage.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  var helper = Helpers();
  var isLoading = false.obs;
  Future signIn(context, String email, String password) async {
    isLoading.value = true;
    try {
      var body = {'email': email, 'password': password};

      var response =
          await http.post(Uri.parse('$apiUrl/guest/login'), body: body);
      isLoading.value = false;
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        userData user = userData.fromJson(data['user']);

        setLoginData(data['access_token'], data['token'], user);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const bottomNavbar(),
        ));
      } else {
        helper.showScafoldMessage(
            context, json.decode(response.body)['message']);
        debugPrint(json.decode(response.body).toString());
      }
    } catch (e) {
      isLoading.value = false;
      helper.showScafoldMessage(context, e.toString());
    }
  }

  Future deleteAccount(context) async {
    isLoading.value = true;
    final bridge = await SharedPreferences.getInstance();
    try {
      var header = {'Authorization': bridge.get('access_token').toString()};

      var response = await http.post(Uri.parse('$apiUrl/auth/delete-account'),
          headers: header);

      isLoading.value = false;
      if (response.statusCode == 200) {
        helper.showAlertDialog(context, json.decode(response.body)['message']);
        clearDataLogin(context);
      } else {
        helper.showAlertDialog(context, json.decode(response.body)['message']);
      }
    } catch (e) {
      isLoading.value = false;
      helper.showAlertDialog(context, e.toString());
    }
  }

  Future changePassword(String? passwordLama, String? passwordBaru,
      String? passwordKonfirmasi, context) async {
    isLoading.value = true;
    final bridge = await SharedPreferences.getInstance();
    try {
      var body = {
        'password_lama': passwordLama,
        'password_baru': passwordBaru,
        'password_konfirmasi': passwordKonfirmasi
      };

      var headers = {'Authorization': bridge.get('access_token').toString()};

      var response = await http.post(Uri.parse('$apiUrl/auth/change-password'),
          headers: headers, body: body);

      isLoading.value = false;
      if (response.statusCode == 201) {
        helper.showScafoldMessage(
            context, json.decode(response.body)['message']);

        getUser(context);
      } else {
        helper.showScafoldMessage(
            context, json.decode(response.body)['message']);
      }
    } catch (e) {
      isLoading.value = false;
      helper.showScafoldMessage(context, e.toString());
    }
  }

  Future signUp(String? nama, String? email, String? password, context) async {
    isLoading.value = true;
    try {
      var body = {
        'nama': nama.toString(),
        'email': email.toString(),
        'password': password.toString()
      };
      var response =
          await http.post(Uri.parse('$apiUrl/guest/register'), body: body);
      isLoading.value = false;
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        userData user = userData.fromJson(data['user']);
        setLoginData(data['access_token'], data['token'], data['user']);

        var res = jsonDecode(response.body);
        if (data['status']) {
          if (res['status'] == false) {
            throw res['message'];
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const bottomNavbar()),
          );
        } else {
          helper.showScafoldMessage(
              context, json.decode(response.body)['message']);
        }
      } else {
        helper.showScafoldMessage(
            context, json.decode(response.body)['message']);
        // debugPrint(json.decode(response.body).toString());
      }
    } catch (e) {
      isLoading.value = false;
      helper.showScafoldMessage(context, e.toString());
    }
  }

  Future<void> setLoginData(
      String access_token, String token, userData user) async {
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
    isLoading.value = false;
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('access_token')) {
      bridge.clear();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const bottomNavbar()),
    );

    isLoading.value = false;
  }

  void getUser(context) async {
    try {
      final bridge = await SharedPreferences.getInstance();

      if (bridge.containsKey('user') && bridge.getString('user') != null) {
        final user =
            jsonDecode(bridge.getString('user')!) as Map<String, dynamic>;

        userData dataUser = userData.fromJson(user);

        Navigator.of(context).push(
          PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  profilePage(userDataStorage: dataUser),
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }),
        );
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      }
    } catch (e) {
      Helpers().showScafoldMessage(context, e.toString());
    }
  }
}
