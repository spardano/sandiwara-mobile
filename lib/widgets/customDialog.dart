// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwara/pages/loginPage.dart';

class customDialog extends StatelessWidget {
  const customDialog(
      {Key? key, required this.header, required this.text, required this.type})
      : super(key: key);

  final String text;
  final String type;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          CardDialog(
            text: text,
            type: type,
            header: header,
          ),
          Positioned(
            top: 0,
            right: 0,
            height: 28,
            width: 28,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(6),
                shape: const CircleBorder(),
                backgroundColor: Colors.red,
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  const CardDialog(
      {Key? key, required this.header, required this.text, required this.type})
      : super(key: key);

  final String text;
  final String type;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == 'success' ? Icons.check : Icons.warning,
            color: type == 'success' ? Colors.green[700] : Colors.amber[700],
            size: 60.0,
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            header,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 32,
                  ),
                  foregroundColor: Colors.red[700],
                  side: BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 32,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Ok'),
              )
            ],
          )
        ],
      ),
    );
  }
}
