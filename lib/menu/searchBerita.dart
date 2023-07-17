import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/constant.dart';
import 'package:sandiwara/models/articleList.dart';
import 'package:sandiwara/models/news.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:sandiwara/widgets/card_news.dart';
import 'package:sandiwara/widgets/imageContainer.dart';
import 'package:http/http.dart' as http;

class searchBerita extends StatefulWidget {
  const searchBerita({super.key});

  @override
  State<searchBerita> createState() => _searchBeritaState();
}

class _searchBeritaState extends State<searchBerita> {
  int page = 1;
  List<ArticleList> articleList = <ArticleList>[];
  String keyword = '';
  final ScrollController _listController = ScrollController();
  Timer? _debounce;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _listController.addListener(() {
      if (_listController.position.maxScrollExtent ==
          _listController.position.pixels) {
        page++;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future getListArtikel() async {
    try {
      var response = await http.post(
          Uri.parse('$apiUrl/guest/search-article?page=$page'),
          body: {'cari': keyword});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        for (Map<String, dynamic> item in data['data']['data_article']) {
          articleList.add(ArticleList.fromJson(item));
        }
        return articleList;
      }
    } catch (e) {
      Helpers().showScafoldMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Temukan Berita',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Dapatkan berita terbaru dari berbagai sumber',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Cari Berita',
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: const RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.tune,
                        color: Colors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: (word) {
                    setState(() {
                      keyword = word;
                      articleList.clear();
                    });
                  },
                )
              ],
            ),
          ),
          FutureBuilder(
            future: getListArtikel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    controller: _listController,
                    itemCount: snapshot.data!.length ?? 0,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CardNews(
                        slug: snapshot.data![index].slug!,
                        image: snapshot.data![index].image!,
                        tanggalPublish: snapshot.data![index].tanggal_publish!,
                        jumlahView: snapshot.data![index].jumlahView.toString(),
                        title: snapshot.data![index].title,
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return const Center(
                  child: Text("Data tidak ditemukan "),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
