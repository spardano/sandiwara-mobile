// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/pages/registerPage.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sandiwara/widgets/button_login.dart';
import 'package:sandiwara/widgets/draw_clilp_2.dart';
import 'package:sandiwara/widgets/draw_clip.dart';
import 'package:sandiwara/widgets/text_field_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => __LoginPageState();
}

class __LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Auth _authenticationController = Get.put(Auth());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AutovalidateMode _autovalidate = AutovalidateMode.onUserInteraction;

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
                                sufixIcon: false,
                                obscureText: false,
                                controller: _emailController,
                                hintText: "Masukkan email",
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  RegExp regex = RegExp(r'\w+@\w+\.\w+');
                                  if (value == null) {
                                    return 'Email harus diisikan';
                                  } else if (!regex.hasMatch(value)) {
                                    return 'Masukkan email yang valid';
                                  }
                                  return null;
                                }),
                            TextFieldInput(
                                sufixIconColor: Colors.white,
                                errorTextColor: Colors.yellow,
                                textColor: Colors.white,
                                textHintColor: Colors.grey,
                                sufixIcon: true,
                                obscureText: true,
                                controller: _passwordController,
                                hintText: "Masukkan Password",
                                icon: Icon(
                                  Icons.key,
                                  color: Colors.white,
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ButtonLogin(onPress: () {
                        if (_emailController.text.isEmpty) {
                          Helpers().showScafoldMessage(
                              context, "Email tidak boleh kosong");
                        } else if (!_emailController.text.isEmail) {
                          Helpers().showScafoldMessage(
                              context, "Email tidak valid !");
                        } else if (_passwordController.text.isEmpty) {
                          Helpers().showScafoldMessage(
                              context, "Password tidak boleh kosong");
                        } else if (_passwordController.text.length < 8) {
                          Helpers().showScafoldMessage(
                              context, "Password harus minimal 8 karakter");
                        } else {
                          _authenticationController.signIn(
                              context,
                              _emailController.text.trim(),
                              _passwordController.text.trim());
                        }
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Belum memiliki akun ?",
                        style: TextStyle(
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const registerPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar Akun",
                            style: TextStyle(
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
