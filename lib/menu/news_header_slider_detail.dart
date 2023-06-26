// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/models/commentArticle.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/models/newsHeaderModel.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class headerSliderDetail extends StatefulWidget {
  detailArticle? detail_article;

  headerSliderDetail({Key? key, this.detail_article}) : super(key: key);

  _headerSliderDetailState createState() =>
      _headerSliderDetailState(detail_article);
}

class _headerSliderDetailState extends State<headerSliderDetail> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  // late Future<List<commentArticle>> commentList;
  List<commentArticle>? commentList;
  detailArticle? detail_article;
  _headerSliderDetailState(this.detail_article);

  @override
  void initState() {
    super.initState();
    getComments();
  }

  // getDataComment() {
  //   try {
  //     print(detail_article!.id!);
  //     commentList = Provider.of<Article>(context, listen: false)
  //         .getComments(int.parse(detail_article!.id!));
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  void getComments() async {
    List<commentArticle> commentsData = [];
    try {
      var response = await http.post(
          Uri.parse(apiUrl + '/guest/comments-article'),
          body: {'id_article': detail_article!.id!.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('status comments :' + data['status'].toString());

        for (Map<String, dynamic> item in data['data']) {
          commentsData.add(commentArticle.fromJson(item));
        }
        commentList = commentsData;
        print(commentList);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var item in commentList!)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: "assets/images/avatar.png")),
                ),
              ),
              title: Text(
                item.nama_user!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.message!),
              trailing:
                  Text(item.tanggal_comment!, style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                          height: 500,
                          child: CommentBox(
                            userImage: CommentBox.commentImageParser(
                                imageURLorPath: "assets/images/avatar.png"),
                            child: commentChild(commentList),
                            labelText: 'Write a comment...',
                            errorText: 'Comment cannot be blank',
                            withBorder: false,
                            formKey: formKey,
                            commentController: commentController,
                            backgroundColor: Colors.red[600],
                            textColor: Colors.white,
                            sendWidget: Icon(Icons.send_sharp,
                                size: 30, color: Colors.white),
                          ));
                    });
              },
              backgroundColor: Colors.black87,
              child: const Icon(Icons.comment),
            ),
          ),
        ));
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
                  padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ),
              ),
            ),
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
