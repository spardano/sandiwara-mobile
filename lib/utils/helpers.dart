import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Helpers {
  showAlertDialog(BuildContext context, String text) {
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Ok"),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Webview App"),
      content: Text(text),
      actions: [okButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  showScafoldMessage(context, String message) async {
    var snackBar = SnackBar(content: Text(message.toString()));
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showLoading(status) {
    return const CircularProgressIndicator();
  }
}
