// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_collection_literals

import 'dart:convert';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/components/article/comment_child.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/controller/CommentController.dart';
import 'package:sandiwara/main.dart';
import 'package:sandiwara/menu/mySliverAppBar.dart';
import 'package:sandiwara/models/commentArticle.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:sandiwara/widgets/customTag.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class headerSliderDetail extends StatefulWidget {
  final detailArticle? detail_article;

  const headerSliderDetail({Key? key, this.detail_article}) : super(key: key);

  _headerSliderDetailState createState() =>
      _headerSliderDetailState(detail_article);
}

class _headerSliderDetailState extends State<headerSliderDetail> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final CommentController commentControllerX = Get.put(CommentController());
  // late Future<List<commentArticle>> commentList;
  List<commentArticle>? commentList;
  detailArticle? detail_article;
  _headerSliderDetailState(this.detail_article);
  bool isCommentListShow = false;
  bool isAuthenticated = false;
  String token = '';
  String? profile_picture;
  int id_user = 0;
  

  @override
  void initState() {
    super.initState();
    checkToken();
    getComments();
  }

  void checkToken() async {
    final bridge = await SharedPreferences.getInstance();
    if (bridge.containsKey('access_token')) {
      var data_token = bridge.getString('access_token');
      token = data_token.toString();
      isAuthenticated = true;
    }

    if (bridge.containsKey('user')) {
      final user = jsonDecode(bridge.getString('user')!);
      id_user = int.parse(user['id']);
      profile_picture = user['profile_picture'];
    }
  }

  void getComments() async {
    commentList = await commentControllerX.getComments(detail_article!.id!);
  }

  @override
  Widget build(BuildContext context) {
    /// Hero animation for image

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverPersistentHeader(
                  delegate: MySliverAppBar(
                      expandedHeight: height - 0.0,
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
                            "${detail_article!.jumlahView!.toString()} Pembaca",
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(
                      detail_article!.title!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                for (var item in detail_article!.content!)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Text(
                          item.desc!,
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
                                  child: GestureDetector(
                                    onTap: () async {
                                      final Uri url = Uri.parse(
                                          detail_article!.url_source!);
                                      if (!await launchUrl(url)) {
                                        throw Exception(
                                            'Could not launch the link');
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 20.0),
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[600],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: CommentBox(
                                userImage: CommentBox.commentImageParser(
                                    imageURLorPath: profile_picture != null ? '$mainUrl/storage/$profile_picture' : "assets/images/avatar.png"),
                                child: Obx((){
                                  if(commentControllerX.isCommentListShow.value){
                                    return commentChild(commentList);
                                  }else{
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text("Belum ada data komentar"),);
                                  }
                                }),
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
                                              detail_article!.id!,
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
                                        builder: (context) => customDialog(
                                              header: 'Peringantan',
                                              text:
                                                  'Anda harus login untuk melanjutkan!',
                                              type: 'warning',
                                            ));
                                  }
                                },
                                backgroundColor: Colors.red[600],
                                textColor: Colors.white,
                                sendWidget: Icon(Icons.send_sharp,
                                    size: 30, color: Colors.white),
                              ),
                            )),
                      );
                    });
              },
              backgroundColor: Colors.black87,
              child: const Icon(Icons.comment, color: Colors.white,),
            ),
          ),
        ));
  }
}
