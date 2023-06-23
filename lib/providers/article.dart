// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/menu/news_header_slider_detail.dart';
import 'package:sandiwara/models/detailArticle.dart';
import 'package:sandiwara/models/newsHeaderModel.dart';

class Article with ChangeNotifier {
  void getDetailArtikel(context, String slug) async {
    try {
      var response = await http.post(
          Uri.parse(apiUrl + '/guest/detail-article'),
          body: {'slug': slug.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('status article :' + data['status'].toString());

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
                }),
          );
        }
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
