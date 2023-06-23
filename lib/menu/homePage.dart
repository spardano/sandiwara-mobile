import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/menu/detailArticle.dart';
import 'package:sandiwara/menu/news_header_slider_detail.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/models/newsHeaderModel.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/providers/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final GlobalKey webViewKey = GlobalKey();
  bool isAuthenticated = false;
  String token = "";
  String? id_user = null;

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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  WebView(
                    gestureNavigationEnabled: true,
                    initialUrl: mainUrl + '/webview/home',
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels:
                        <JavascriptChannel>[_jsDataCallback(context)].toSet(),
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
            ),
          ],
        ),
      ),
    );
  }

  JavascriptChannel _jsDataCallback(BuildContext context) {
    return JavascriptChannel(
        name: 'DataCallback',
        onMessageReceived: (JavascriptMessage message) {
          print(message);
          _doDirectToDetailPage(context, message.message);
        });
  }

  _doDirectToDetailPage(BuildContext context, String textData) {
    final slug = jsonDecode(textData) as Map<String, dynamic>;
    print(slug['slug_article']);

    try {
      Provider.of<Article>(context, listen: false)
          .getDetailArtikel(context, slug['slug_article']);
    } catch (err) {
      print(err);
    }
  }
}
