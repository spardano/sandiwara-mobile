import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:sandiwara/widgets/draw_clilp_2.dart';
import 'package:sandiwara/widgets/draw_clip.dart';
import 'package:sandiwara/widgets/text_field_input.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  Map<String?, String?> _registerObject = Map<String?, String?>();
  //create a TexteditingController
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordKonfirmasiController =
      TextEditingController();
  final Auth _autenticationController = Get.put(Auth());
  final AutovalidateMode _autovalidate = AutovalidateMode.onUserInteraction;
  String? pass;

  // Create a controller for the password TextFormField
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: DrawClip2(),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.83,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFE5A8),
                            Color.fromARGB(255, 174, 27, 32)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.bottomRight),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: DrawClip(),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.84,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 214, 118, 22),
                        Color.fromARGB(255, 209, 13, 43)
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          /// Animation text treva shop accept from login layout
                        ],
                      ),
                      Image.asset(
                        "assets/images/logo_sandiwara.png",
                        width: 250,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: _autovalidate,
                        child: Column(
                          children: [
                            TextFieldInput(
                                sufixIconColor: Colors.white,
                                errorTextColor: Colors.yellow,
                                textColor: Colors.white,
                                textHintColor: Colors.grey,
                                controller: _namaController,
                                icon: const Icon(
                                  Icons.card_membership,
                                  color: Colors.white,
                                ),
                                hintText: "Masukkan Nama",
                                validator: (value) {
                                  if (value == null) {
                                    return 'Nama tidak boleh kosong';
                                  }
                                  if (!RegExp(r'.{2,}').hasMatch(value!)) {
                                    return 'Nama harus minimal 2 karakter';
                                  }
                                },
                                obscureText: false,
                                sufixIcon: false),
                            TextFieldInput(
                                sufixIconColor: Colors.white,
                                errorTextColor: Colors.yellow,
                                textColor: Colors.white,
                                textHintColor: Colors.grey,
                                controller: _emailController,
                                icon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: "Masukkan Email",
                                validator: (value) {
                                  RegExp regex = RegExp(r'\w+@\w+\.\w+');
                                  if (value == null) {
                                    return 'Email ridak boleh kosong';
                                  } else if (!regex.hasMatch(value)) {
                                    return 'Masukkan email yang valid';
                                  }
                                },
                                obscureText: false,
                                sufixIcon: false),
                            TextFieldInput(
                              sufixIconColor: Colors.white,
                              errorTextColor: Colors.yellow,
                              textColor: Colors.white,
                              textHintColor: Colors.grey,
                              controller: _passwordController,
                              icon: const Icon(
                                Icons.key,
                                color: Colors.white,
                              ),
                              hintText: "Masukkan Password",
                              validator: (value) {
                                RegExp hasUpper = RegExp(r'[A-Z]');
                                RegExp hasLower = RegExp(r'[a-z]');
                                RegExp hasDigit = RegExp(r'\d');
                                RegExp hasPunct = RegExp(r'[!@#\$&*~-]');
                                if (!RegExp(r'.{8,}').hasMatch(value!)) {
                                  return 'Password harus minimal 8 karakter';
                                }
                              },
                              obscureText: true,
                              sufixIcon: true,
                            ),
                            TextFieldInput(
                              sufixIconColor: Colors.white,
                              errorTextColor: Colors.yellow,
                              textColor: Colors.white,
                              textHintColor: Colors.grey,
                              controller: _passwordKonfirmasiController,
                              icon: const Icon(
                                Icons.key,
                                color: Colors.white,
                              ),
                              hintText: "Masukkan Konfirmasi Password",
                              validator: (value) {
                                if (!RegExp(r'.{8,}').hasMatch(value!)) {
                                  return 'Password harus minimal 8 karakter';
                                }
                                if (value != _passwordController.text) {
                                  return 'Komfirmasi password tidak sesuai';
                                }
                              },
                              obscureText: true,
                              sufixIcon: true,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SizedBox(
                          width: 280,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16.0),
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    Helpers().showScafoldMessage(
                                        context, "Data tidak valid !");
                                  } else if (_namaController.text.isEmpty) {
                                    Helpers().showScafoldMessage(
                                        context, "Nama tidak valid !");
                                  } else if (_emailController.text.isEmpty) {
                                    Helpers().showScafoldMessage(
                                        context, "Email tidak boleh kosong !");
                                  } else if (!_emailController.text.isEmail) {
                                    Helpers().showScafoldMessage(
                                        context, "Email tidak valid !");
                                  } else if (_passwordController.text.length <
                                      8) {
                                    Helpers().showScafoldMessage(context,
                                        "Password kurang dari 8 digits !");
                                  } else if (_passwordKonfirmasiController.text
                                          .trim() !=
                                      _passwordController.text.trim()) {
                                    Helpers().showScafoldMessage(
                                        context, "Password tidak sama !");
                                  } else {
                                    _formKey.currentState!.save();
                                    _autenticationController.signUp(
                                        _namaController.text,
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                        context);
                                  }
                                },
                                child: Center(child: Obx(
                                  () {
                                    return _autenticationController
                                            .isLoading.value
                                        ? LoadingAnimationWidget.inkDrop(
                                            color: Colors.white, size: 20)
                                        : const Text('Daftar');
                                  },
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 540.0),
                  child: Column(
                    children: const [],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
