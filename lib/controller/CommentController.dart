import 'dart:convert';

import 'package:get/get.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/models/commentArticle.dart';
import 'package:http/http.dart' as http;

class CommentController extends GetxController {

  var isLoading = false.obs;
  var isCommentListShow = false.obs;
  List<commentArticle>? commentList;

  Future<List<commentArticle>?> getComments(id_article) async {
    List<commentArticle> commentsData = [];
    try {
      var response = await http.post(
          Uri.parse('$apiUrl/guest/comments-article'),
          body: {'id_article': id_article.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        for (Map<String, dynamic> item in data['data']) {
          commentsData.add(commentArticle.fromJson(item));
        }
        commentList = commentsData;
        isCommentListShow(true);
      }

      return commentList;

    } catch (e) {
      print(e.toString());
    }
  }


} 