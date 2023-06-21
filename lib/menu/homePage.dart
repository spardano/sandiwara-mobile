import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sandiwara/constant.dart';
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

  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  getToken() async {
    final bridge = await SharedPreferences.getInstance();

    if (bridge.containsKey('data_login') &&
        bridge.getString('data_login') != null) {
      final myData =
          jsonDecode(bridge.getString('data_login')!) as Map<String, dynamic>;

      if (myData['access_token'] != null) {
        isAuthenticated = true;
        token = myData['token'];
        id_user = myData['id_user'];
        webViewController?.loadUrl(
            urlRequest: URLRequest(
                url: Uri.parse(mainUrl + '/webview/auth/home/' + token)));
      }

      print(isAuthenticated);
    }
  }

  @override
  void initState() {
    super.initState();
    // getToken();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return FutureBuilder(
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        gestureRecognizers: {
                          Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())
                        },
                        initialUrlRequest: URLRequest(
                          url: Uri.parse(url),
                        ),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
                          getToken();
                          // setState(() {
                          //   this.url = url.toString();
                          //   urlController.text = this.url;
                          // });
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme)) {
                            if (await canLaunchUrl(Uri.parse(url))) {
                              // Launch the App
                              await launchUrl(
                                Uri.parse(url),
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController.endRefreshing();
                          // setState(() {
                          //   this.url = url.toString();
                          //   urlController.text = this.url;
                          // });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          // setState(() {
                          //   this.progress = progress / 100;
                          // });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
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
      },
    );
  }
}
