import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:sandiwara/constant.dart';

Widget commentChild(commentList) {

  if(commentList != null){
    return ListView(
      children: [
        for (var item in commentList)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  print(item.profile_picture);
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath:
                              '$mainUrl/storage/${item.profile_picture}' ??
                                  "assets/images/avatar.png")),
                ),
              ),
              title: Text(
                item.nama_user!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.message!),
              trailing: Text(item.tanggal_comment!,
                  style: const TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }else{
    return const Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Belum ada data komentar"),
      );
  }
}
