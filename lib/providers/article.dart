// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/menu/news_header_slider_detail.dart';
import 'package:sandiwara/models/articleList.dart';
import 'package:sandiwara/models/commentArticle.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/models/newsHeaderModel.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:sandiwara/widgets/customDialog.dart';
import 'package:get/get.dart';

class Article with ChangeNotifier {
  var helper = Helpers();
  var isLoading = false.obs;

  void getDetailArtikel(context, String slug) async {
    try {
      var response = await http.post(Uri.parse('$apiUrl/guest/detail-article'),
          body: {'slug': slug.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('status article :${data['status']}');

        final detailArticle detail_article =
            detailArticle.fromJson(data['data']);

        if (data['status']) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => headerSliderDetail(
                detail_article: detail_article,
              ),
              transitionDuration: Duration(milliseconds: 600),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              },
            ),
          );
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => customDialog(
                  header: 'Gagal',
                  text: 'Berita gagal ditemukan, coba kembali',
                  type: 'warning',
                ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void saveComment(
      int id_user, String? id_article, String text, String token) async {
    try {
      var response = await http.post(Uri.parse('$apiUrl/auth/store-comment'),
          headers: {'Authorization': token},
          body: {'message': text, 'id_article': id_article});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<commentArticle>> getComments(int id_article) async {
    List<commentArticle> commentList = [];
    try {
      var response = await http.post(
          Uri.parse('$apiUrl/guest/comments-article'),
          body: {'id_article': id_article.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('status comments :${data['status']}');

        for (Map<String, dynamic> item in data['data']) {
          commentList.add(commentArticle.fromJson(item));
          print(item);
        }

        return commentList;
      } else {
        return commentList;
      }
    } catch (e) {
      print(e.toString());
      return commentList;
    }
  }
}
