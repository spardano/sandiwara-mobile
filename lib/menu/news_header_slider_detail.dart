// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/models/newsHeaderModel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class headerSliderDetail extends StatefulWidget {
  detailArticle? detail_article;

  headerSliderDetail({Key? key, this.detail_article}) : super(key: key);

  _headerSliderDetailState createState() =>
      _headerSliderDetailState(detail_article);
}

class _headerSliderDetailState extends State<headerSliderDetail> {
  detailArticle? detail_article;
  _headerSliderDetailState(this.detail_article);

  @override
  Widget build(BuildContext context) {
    double _fullHeight = MediaQuery.of(context).size.height;

    /// Hero animation for image
    final hero = Hero(
      tag: 'hero-tag-${detail_article!.id}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(detail_article!.image!),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 130.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                const Color(0xFF000000),
                const Color(0x00000000),
              ],
            ),
          ),
        ),
      ),
    );

    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  expandedHeight: _height - 0.0,
                  img: detail_article!.image,
                  id: detail_article!.id,
                  title: detail_article!.title,
                  category: detail_article!.category,
                  author: detail_article!.author),
              pinned: true,
            ),
            SliverFillRemaining(
              child: WebView(
                // initialUrl: 'https://sandiwara.id/webview/home',
                initialUrl: mainUrl +
                    '/webview/detail-article/' +
                    detail_article!.slug!,
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (String url) {
                  setState(() {});
                },
                onPageFinished: (String url) {
                  setState(() {});
                },
                onWebViewCreated: (controller) {
                  // this.controller = controller;
                },
                gestureRecognizers: {
                  Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String? img, id, title, category, author;

  MySliverAppBar(
      {required this.expandedHeight,
      this.img,
      this.id,
      this.title,
      this.category,
      this.author});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: Color(0xFF172E4D),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            transitionOnUserGestures: true,
            tag: 'hero-tag-${id}',
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(img!),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(top: 130.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: <Color>[
                      const Color(0xFF000000),
                      const Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(
                      title!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.5,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    child: Text(
                      author!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.5,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w400),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Icon(Icons.arrow_back),
                    ))),
            Container(
              padding: EdgeInsets.all(12.0),
              width: c_width,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  category!,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gotik",
                    fontWeight: FontWeight.w700,
                    fontSize: (expandedHeight / 40) - (shrinkOffset / 40) + 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 36.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
