import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/constant.dart';
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
        setLoginData(data['access_token'], data['token'], data['id_user']);
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
        setLoginData(data['access_token'], data['token'], data['id_user']);

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

  Future setLoginData(String accessToken, String token, int idUser) async {
    isLoading.value = true;
    final bridge = await SharedPreferences.getInstance();

    final myData = jsonEncode({
      'access_token': accessToken.toString(),
      'token': token.toString(),
      'id_user': idUser.toString()
    });

    if (bridge.containsKey('data_login')) {
      bridge.clear();
    }

    bridge.setString('data_login', myData);
    isLoading.value = false;
  }

  Future<String?> getToken() async {
    isLoading.value = true;
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('data_login') &&
        bridge.getString('data_login') != null) {
      final myData =
          jsonDecode(bridge.getString('data_login')!) as Map<String, dynamic>;
      isLoading.value = false;
      return myData['access_token'];
    }
    isLoading.value = true;
    return null;
  }

  Future<void> clearDataLogin(context) async {
    isLoading.value = false;
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('data_login')) {
      bridge.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => bottomNavbar()),
      );
    }

    isLoading.value = false;
  }
}
