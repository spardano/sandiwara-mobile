import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandiwara/constant.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/models/user_data.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Future<void> updateNotificationStatus(
      bool statusSwitch, String status_type) async {
    final bridge = await SharedPreferences.getInstance();
    String token = '';
    if (bridge.containsKey('access_token')) {
      token = bridge.getString('access_token')!;
    }

    var headers = {'Content-Type': 'application/json', 'Authorization': token};

    Uri url = Uri();
    Map body = {};
    if (status_type == 'push-notif') {
      url = Uri.parse('$apiUrl/auth/update-notification');
      body = {'status_notifikasi': statusSwitch};
    }

    if (status_type == 'email-sub') {
      url = Uri.parse('$apiUrl/auth/update-email-sub');
      body = {'status_email_subs': statusSwitch};
    }

    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      final json = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json["status"]) {
          if (status_type == 'push-notif') {
            //update preference
            updateStatusNotificationStorage(statusSwitch);
          }

          if (status_type == 'email-sub') {
            //update preference
            updateStatusEmailSubStorage(statusSwitch);
          }
        } else {
          throw jsonDecode(response.body)['message'] ?? 'Error tidak diketahui';
        }
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Error tidak diketahui';
      }
    } catch (e) {
      print(e.toString());
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) => customDialog(
                header: 'Gagal',
                text: e.toString(),
                type: 'warning',
                direction: null,
              ));
    }
  }

  void updateStatusNotificationStorage(bool statusNotification) async {
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('user') && bridge.getString('user') != null) {
      var user_map =
          jsonDecode(bridge.getString('user')!) as Map<String, dynamic>;
      userData user = userData.fromJson(user_map);

      if (user.push_notif != null) {
        var numberStatus = statusNotification == true ? 1 : 0;
        user.push_notif = numberStatus;

        final updateMyData = userData.encode(user);

        if (bridge.containsKey('user')) {
          bridge.remove('user');
        }

        bridge.setString('user', updateMyData);

        //snackbar or dialog
        Get.back();
        showDialog(
            context: Get.context!,
            builder: (context) => const customDialog(
                  header: 'Berhasil',
                  text: 'Berhasil mengubah status',
                  type: 'warning',
                ));
      }
    }
  }

  void updateStatusEmailSubStorage(bool statusEmailSub) async {
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('user') && bridge.getString('user') != null) {
      var user_map =
          jsonDecode(bridge.getString('user')!) as Map<String, dynamic>;
      userData user = userData.fromJson(user_map);

      if (user.email_news_subs != null) {
        var numberStatus = statusEmailSub == true ? 1 : 0;
        user.email_news_subs = numberStatus;

        final updateMyData = userData.encode(user);

        if (bridge.containsKey('user')) {
          bridge.remove('user');
        }

        bridge.setString('user', updateMyData);

        //snackbar or dialog
        Get.back();
        showDialog(
            context: Get.context!,
            builder: (context) => const customDialog(
                  header: 'Berhasil',
                  text: 'Berhasil mengubah status',
                  type: 'warning',
                ));
      }
    }
  }
}
