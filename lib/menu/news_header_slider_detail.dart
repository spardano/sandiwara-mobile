// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_collection_literals

import 'dart:convert';
import 'dart:ffi';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/models/commentArticle.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/models/newsHeaderModel.dart';
import 'package:sandiwara/pages/loginPage.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:sandiwara/widgets/customTag.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isCommentListShow = false;
  bool isAuthenticated = false;
  String token = '';
  int id_user = 0;

  @override
  void initState() {
    super.initState();
    checkToken();
    getComments();
  }

  void checkToken() async {
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('data_login')) {
      final data =
          jsonDecode(bridge.getString('data_login')!) as Map<String, dynamic>;
      isAuthenticated = true;
      token = data['access_token'];
      id_user = int.parse(data['id_user']);
    }
  }

  void getComments() async {
    List<commentArticle> commentsData = [];
    try {
      var response = await http.post(
          Uri.parse('$apiUrl/guest/comments-article'),
          body: {'id_article': detail_article!.id!.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('status comments :${data['status']}');

        for (Map<String, dynamic> item in data['data']) {
          commentsData.add(commentArticle.fromJson(item));
        }
        commentList = commentsData;
        isCommentListShow = true;
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
    double _webviewHeight;

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
                  floating: false),
              SliverToBoxAdapter(
                  child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 40.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomTag(backgroundColor: Colors.red, children: [
                          Text(
                            detail_article!.category!,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ]),
                        SizedBox(
                          width: 10.0,
                        ),
                        CustomTag(backgroundColor: Colors.black54, children: [
                          Text(
                            detail_article!.author!,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ]),
                        SizedBox(
                          width: 10.0,
                        ),
                        CustomTag(backgroundColor: Colors.black54, children: [
                          Text(
                            detail_article!.tanggal_publish!,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ]),
                        SizedBox(
                          width: 10.0,
                        ),
                        CustomTag(backgroundColor: Colors.black54, children: [
                          Icon(
                            Icons.ads_click,
                            size: 15.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            detail_article!.jumlahView!.toString() + " Pembaca",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ]),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(
                      detail_article!.title!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                for (var item in detail_article!.content!)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Text(
                          item!.desc!,
                          style: TextStyle(
                              fontFamily: "Sofia",
                              color: Colors.black,
                              fontSize: 17.0,
                              height: 1.5,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      if (item.other != null)
                        Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 20.0),
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[600],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Baca Juga",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          item.other!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ],
                  ),
                SizedBox(
                  height: 50.0,
                )
              ])),
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
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                            height: 500,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: CommentBox(
                                  userImage: CommentBox.commentImageParser(
                                      imageURLorPath:
                                          "assets/images/avatar.png"),
                                  child: isCommentListShow
                                      ? commentChild(commentList)
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child:
                                              Text("Belum ada data komentar"),
                                        ),
                                  labelText: 'Tulis Komentar...',
                                  errorText: 'Komentar tidak boleh kosong',
                                  withBorder: false,
                                  formKey: formKey,
                                  commentController: commentController,
                                  sendButtonMethod: () {
                                    if (isAuthenticated) {
                                      if (formKey.currentState!.validate()) {
                                        Provider.of<Article>(context,
                                                listen: false)
                                            .saveComment(
                                                id_user,
                                                this.detail_article!.id!,
                                                commentController.text,
                                                token);

                                        Navigator.pop(context);
                                        setState(() {
                                          print('update comment');
                                          getComments();
                                        });
                                        commentController.clear();
                                        FocusScope.of(context).unfocus();
                                      } else {
                                        print("Not validated");
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => customDialog());
                                    }
                                  },
                                  backgroundColor: Colors.red[600],
                                  textColor: Colors.white,
                                  sendWidget: Icon(Icons.send_sharp,
                                      size: 30, color: Colors.white),
                                ),
                              ),
                            )),
                      );
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
    double c_width = MediaQuery.of(context).size.width * 0.6;
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
                color: Colors.red[600],
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: CustomTag(
                    backgroundColor: Colors.grey.withAlpha(150),
                    children: [
                      Text(
                        category!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(
                      title!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
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
