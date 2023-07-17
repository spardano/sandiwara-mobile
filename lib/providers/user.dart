import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sandiwara/models/user.dart';
import 'package:get/get.dart';
import 'package:sandiwara/utils/helpers.dart';

class User with ChangeNotifier {
  var isLoading = false.obs;
  var nama;
  var email;

  void getUser(context) {}
}
