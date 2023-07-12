// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/menu/homePage.dart';
import 'package:sandiwara/pages/registerPage.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:sandiwara/utils/authentication.dart';
import 'package:sandiwara/widgets/googleSignInButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String?, String?> _loginObject = Map<String?, String?>();

  //create a TexteditingController
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.always;
  String? pass;
  bool _passwordVisible = true;

  @override
  void dispose() {
    super.dispose();
  }

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
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _buildEmailField,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _buildPasswordField,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
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
                                  _doLogin();
                                },
                                child: const Center(child: Text('Login')),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // const Text("Forgot your password?",
                      //     style: TextStyle(
                      //         fontFamily: "Sofia",
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 540.0),
                  child: Column(
                    children: [
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
                            //register
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => registerPage()));
                          },
                          child: const Text(
                            "Daftar Akun",
                            style: TextStyle(
                              fontFamily: "Sofia",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 20, horizontal: 20),
                      //   child: Row(
                      //     children: [
                      //       FutureBuilder(
                      //         future: Authentication.initializeFirebase(
                      //             context: context),
                      //         builder: (context, snapshot) {
                      //           if (snapshot.hasError) {
                      //             return Text('Error initializing Firebase');
                      //           } else if (snapshot.connectionState ==
                      //               ConnectionState.done) {
                      //             return googleSignInButton();
                      //           }
                      //           return const CircularProgressIndicator(
                      //             valueColor: AlwaysStoppedAnimation<Color>(
                      //               Colors.red,
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: AppOutlineButton(
                      //           asset: "assets/images/facebook.png",
                      //           onTap: () {},
                      //         ),
                      //       ),
                      //       const SizedBox(width: 12),
                      //     ],
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: const [
                      //     Text("Don't have an account? ",
                      //         style: TextStyle(
                      //             fontFamily: "Sofia",
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.blueGrey)),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text("Sign Up",
                      //         style: TextStyle(
                      //             fontFamily: "Sofia",
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.blueGrey))
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildEmailField {
    return TextFormField(
      onSaved: (String? val) {
        _loginObject['email'] = val;
      },
      validator: (val) {
        RegExp regex = RegExp(r'\w+@\w+\.\w+');
        if (val == null)
          return 'Emaril harus diisikan';
        else if (!regex.hasMatch(val)) return 'Masukkan email yang valid';
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.white, fontFamily: "Sofia"),
        errorStyle: TextStyle(color: Colors.orange[300], fontSize: 14.0),
        hintText: 'Masukkan email',
        icon: Icon(Icons.person, color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget get _buildPasswordField {
    return TextFormField(
      obscureText: _passwordVisible,
      style: TextStyle(color: Colors.white),
      onChanged: (String val) => setState(() => pass = val),
      onSaved: (String? val) => _loginObject['password'] = val,
      validator: (String? val) {
        RegExp hasUpper = RegExp(r'[A-Z]');
        RegExp hasLower = RegExp(r'[a-z]');
        RegExp hasDigit = RegExp(r'\d');
        RegExp hasPunct = RegExp(r'[!@#\$&*~-]');

        if (!RegExp(r'.{8,}').hasMatch(val!))
          return 'Password harus minimal 8 karakter';
        if (!hasDigit.hasMatch(val))
          return 'Passwords harus berisi satu buah angka';
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Password',
        hintStyle: const TextStyle(color: Colors.white, fontFamily: "Sofia"),
        icon: const Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        errorStyle: TextStyle(color: Colors.orange[300], fontSize: 14.0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  void _doLogin() async {
    setState(() => _autovalidate = AutovalidateMode.always);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Provider.of<Auth>(context, listen: false)
            .signIn(_loginObject['email'], _loginObject['password'], context);
      } catch (err) {
        print(err);
      }
    }
  }
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.80);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height / 2, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DrawClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.08);
    path.cubicTo(size.width / 4, size.height, 3 * size.width / 4,
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class AppOutlineButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  AppOutlineButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          asset,
          height: 24,
        ),
      ),
      onPressed: onTap,
    );
  }
}
