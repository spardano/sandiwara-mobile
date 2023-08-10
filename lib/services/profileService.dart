import 'package:dio/dio.dart';
import 'package:sandiwara/constant.dart';
import 'dart:developer' as devtools show log;

import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<dynamic> uploadPic(filePath) async {
    //get token
    final bridge = await SharedPreferences.getInstance();
    String accessToken = '';
    if (bridge.containsKey('access_token')) {
      accessToken = bridge.getString('access_token')!;
    }

    try {
      FormData formData = FormData.fromMap(
          {"image": await MultipartFile.fromFile(filePath, filename: "dp")});

      Response response = await Dio().post('$apiUrl/auth/update-profile',
          data: formData,
          options: Options(headers: <String, String>{
            'Content-Type': 'multipart/form-data',
            'Authorization': accessToken,
          }));
      return response;
    } on DioException catch (e) {
      devtools.log(e.response.toString());
      return e.response;
    }
  }
}
