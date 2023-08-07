import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final GlobalKey webViewKey = GlobalKey();
  String? id_user;

  late WebViewController controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            gestureNavigationEnabled: true,
            initialUrl: '$mainUrl/webview/home',
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>{
              _jsDataCallback(context)
            },
            gestureRecognizers: {
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                    ..onDown = (DragDownDetails dragDownDetails) {
                      controller.getScrollY().then((value) {
                        if (value == 0 &&
                            dragDownDetails.globalPosition.direction <
                                1) {
                          controller.reload();
                        }
                      });
                    })
            },
            onPageStarted: (String url) {
              setState(() {});
            },
            onProgress: (progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            onPageFinished: (String url) {
              setState(() {});
            },
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      ),
    );
  }

  JavascriptChannel _jsDataCallback(BuildContext context) {
    return JavascriptChannel(
        name: 'DataCallback',
        onMessageReceived: (JavascriptMessage message) {
          _doDirectToDetailPage(context, message.message);
        });
  }

  _doDirectToDetailPage(BuildContext context, String textData) {
    final slug = jsonDecode(textData) as Map<String, dynamic>;
    try {
      Provider.of<Article>(context, listen: false)
          .getDetailArtikel(context, slug['slug_article']);
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => customDialog(
                header: 'Gagal',
                text: err.toString(),
                type: 'warning',
              ));
    }
  }
}
