import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandiwara/constant.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/models/user_data.dart';
import 'package:sandiwara/services/profileService.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var imageUrl = '';

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

  void updateImage(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      isLoading(true);
      if (pickedFile != null) {
        var response = await ProfileService.uploadPic(pickedFile.path);
        if (response.statusCode == 200) {
          imageUrl =
              mainUrl + '/storage/' + response.data['user']['profile_picture'];
          devtools.log(response.data['user']['profile_picture']);
          updateImageStorage(response.data['user']['profile_picture']);
        } else if (response.statusCode == 401) {
          Get.offAllNamed('/register');
        } else {
          Get.snackbar("Gagal", "Gagal mengubah foto profile!",
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
          isLoading(false);
        }
      }
    } catch (e) {
      devtools.log(e.toString());
    }
  }

  void updateImageStorage(String pathImage) async {
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('user') && bridge.getString('user') != null) {
      var user_map =
          jsonDecode(bridge.getString('user')!) as Map<String, dynamic>;
      userData user = userData.fromJson(user_map);

      user.profile_picture = pathImage;

      final updateMyData = userData.encode(user);

      if (bridge.containsKey('user')) {
        bridge.remove('user');
      }

      bridge.setString('user', updateMyData);

      isLoading(false);
      Get.snackbar("Berhasil", "Foto Profile Berhasil diubah",
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
    }
  }
}
