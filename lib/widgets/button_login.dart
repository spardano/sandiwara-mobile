import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sandiwara/providers/auth.dart';

class ButtonLogin extends StatelessWidget {
  ButtonLogin({
    Key? key,
    required this.onPress,
  }) : super(key: key);
  final VoidCallback onPress;
  final Auth _autenticationController = Get.put(Auth());
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
              onPressed: onPress,
              child: Center(
                child: Obx(() {
                  return _autenticationController.isLoading.value
                      ? LoadingAnimationWidget.inkDrop(
                          color: Colors.white, size: 20)
                      : const Text('Login');
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
