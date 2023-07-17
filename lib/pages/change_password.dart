import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sandiwara/inside/profilePage.dart';
import 'package:sandiwara/models/user_data.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:sandiwara/widgets/custom_button.dart';
import 'package:sandiwara/widgets/text_field_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var bridge;
  var user;
  userData dataUser = userData();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordLamaController = TextEditingController();
  final TextEditingController passwordBaruController = TextEditingController();
  final TextEditingController passwordBaruKonfirmController =
      TextEditingController();
  final AutovalidateMode _autovalidate = AutovalidateMode.onUserInteraction;
  final Auth _autenthicationController = Get.put(Auth());
  getUser() async {
    print("get user");
    bridge = await SharedPreferences.getInstance();
    user = json.decode(bridge.getString('user')!) as Map<String, dynamic>;
    dataUser = userData.fromJson(user);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontFamily: "Lemon",
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
            color: Colors.black87,
          ),
        ),
        elevation: 0.2,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 10, spreadRadius: 0)
                  ],
                ),
                child: Column(
                  children: [
                    CardProfile(
                      nama: dataUser.name != null
                          ? dataUser.name.toString()
                          : 'User',
                      email: dataUser.email != null
                          ? dataUser.email.toString()
                          : 'email@example.com',
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autovalidate,
                        child: Column(
                          children: [
                            TextFieldInput(
                                sufixIconColor: Colors.grey,
                                sufixIcon: true,
                                obscureText: true,
                                errorTextColor: Colors.red,
                                textColor: Colors.black,
                                textHintColor: Colors.grey,
                                controller: passwordLamaController,
                                hintText: "Masukkan password lama",
                                icon: const Icon(
                                  Icons.key,
                                  color: Colors.black45,
                                ),
                                validator: (value) {
                                  RegExp hasUpper = RegExp(r'[A-Z]');
                                  RegExp hasLower = RegExp(r'[a-z]');
                                  RegExp hasDigit = RegExp(r'\d');
                                  RegExp hasPunct = RegExp(r'[!@#\$&*~-]');

                                  if (!RegExp(r'.{8,}').hasMatch(value!)) {
                                    return 'Password harus minimal 8 karakter';
                                  }
                                  if (!hasDigit.hasMatch(value)) {
                                    return 'Passwords harus berisi satu buah angka';
                                  }
                                }),
                            TextFieldInput(
                              sufixIconColor: Colors.grey,
                              sufixIcon: true,
                              obscureText: true,
                              errorTextColor: Colors.red,
                              textColor: Colors.black,
                              textHintColor: Colors.grey,
                              controller: passwordBaruController,
                              hintText: "Masukkan password baru",
                              icon: const Icon(
                                Icons.key,
                                color: Colors.grey,
                              ),
                              validator: (value) {
                                RegExp hasUpper = RegExp(r'[A-Z]');
                                RegExp hasLower = RegExp(r'[a-z]');
                                RegExp hasDigit = RegExp(r'\d');
                                RegExp hasPunct = RegExp(r'[!@#\$&*~-]');

                                if (!RegExp(r'.{8,}').hasMatch(value!)) {
                                  return 'Password harus minimal 8 karakter';
                                }
                                if (!hasDigit.hasMatch(value)) {
                                  return 'Passwords harus berisi satu buah angka';
                                }
                              },
                            ),
                            TextFieldInput(
                              sufixIconColor: Colors.grey,
                              sufixIcon: true,
                              obscureText: true,
                              errorTextColor: Colors.red,
                              textColor: Colors.black,
                              textHintColor: Colors.grey,
                              controller: passwordBaruKonfirmController,
                              hintText: "Masukkan Konfirmasi Password",
                              icon: const Icon(
                                Icons.key,
                                color: Colors.grey,
                              ),
                              validator: (value) {
                                RegExp hasUpper = RegExp(r'[A-Z]');
                                RegExp hasLower = RegExp(r'[a-z]');
                                RegExp hasDigit = RegExp(r'\d');
                                RegExp hasPunct = RegExp(r'[!@#\$&*~-]');

                                if (!RegExp(r'.{8,}').hasMatch(value!)) {
                                  return 'Password harus minimal 8 karakter';
                                }
                                if (!hasDigit.hasMatch(value)) {
                                  return 'Passwords harus berisi satu buah angka';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              buttonText: "Update",
                              onPress: () {
                                if (passwordLamaController.text.isEmpty) {
                                  Helpers().showScafoldMessage(
                                      context, "Password tidak boleh kosong");
                                } else if (passwordBaruController
                                    .text.isEmpty) {
                                  Helpers().showScafoldMessage(
                                      context, "Password tidak boleh kosong");
                                } else if (passwordBaruKonfirmController
                                    .text.isEmpty) {
                                  Helpers().showScafoldMessage(
                                      context, "Password tidak boleh kosong");
                                } else if (passwordLamaController.text.length <
                                        8 ||
                                    passwordBaruController.text.length < 8) {
                                  Helpers().showScafoldMessage(
                                      context, "Password tidak boleh kosong");
                                } else if (passwordBaruController.text.trim() !=
                                    passwordBaruKonfirmController.text.trim()) {
                                  Helpers().showScafoldMessage(
                                      context, "Password tidak boleh kosong");
                                } else {
                                  _autenthicationController.changePassword(
                                      passwordLamaController.text.trim(),
                                      passwordBaruController.text.trim(),
                                      passwordBaruKonfirmController.text.trim(),
                                      context);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
