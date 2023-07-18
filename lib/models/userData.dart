import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class userData {
  userData(
      {this.id, this.name, this.email, this.email_news_subs, this.push_notif});

  final String? id;
  final String? name;
  final String? email;
  var email_news_subs;
  var push_notif;

  factory userData.fromJson(Map<String, dynamic> json) => userData(
      id: json["id"] == null ? null : json["id"].toString(),
      name: json["name"] == null ? null : json["name"],
      email: json["email"] == null ? null : json["email"],
      email_news_subs:
          json["email_news_subs"] == 0 ? 0 : json['email_news_subs'],
      push_notif: json["push_notif"] == 0 ? 0 : json['push_notif']);

  static Map<String, dynamic> toMap(userData user) => {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'email_news_subs': user.email_news_subs,
        'push_notif': user.push_notif
      };

  static String encode(userData user) => jsonEncode(userData.toMap(user));
}
