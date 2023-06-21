import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sandiwara/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class categoryBerita extends StatefulWidget {
  const categoryBerita({super.key});

  @override
  State<categoryBerita> createState() => _categoryBeritaState();
}

class _categoryBeritaState extends State<categoryBerita> {
  bool isLoading = true;
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Kategori",
          style: TextStyle(
              fontFamily: "Lemon",
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
              color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.reload();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.black87,
            ),
          )
        ],
        elevation: 0.2,
      ),
      body: Stack(
        children: [
          WebView(
            // initialUrl: 'https://sandiwara.id/webview/home',
            initialUrl: mainUrl + '/webview/category',
            navigationDelegate: (NavigationRequest request) {
              // if (request.url == 'https://sandiwara.id') {
              //   return NavigationDecision.prevent;
              // }
              if (request.url == mainUrl) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) {
              setState(() {
                isLoading =
                    true; // Show loading indicator when page starts loading
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading =
                    false; // Hide loading indicator when page finishes loading
              });
            },
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
