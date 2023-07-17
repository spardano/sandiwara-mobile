import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sandiwara/bottomNavbar.dart';
import 'package:sandiwara/pages/loginPage.dart';
import 'package:sandiwara/topBar.dart';
import 'package:sandiwara/utils/authentication.dart';
import 'package:sandiwara/widgets/app_outline_button.dart';

class googleSignInButton extends StatefulWidget {
  const googleSignInButton({super.key});

  @override
  State<googleSignInButton> createState() => _googleSignInButtonState();
}

class _googleSignInButtonState extends State<googleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppOutlineButton(
        asset: "assets/images/google.png",
        onTap: () async {
          User? user = await Authentication.signInWithGoogle(context: context);

          if (user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => bottomNavbar(),
              ),
            );
          }
        },
      ),
    );
  }
}
