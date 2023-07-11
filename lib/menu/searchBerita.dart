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
  ScrollController _listController = ScrollController();
  Timer? _debounce;

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
          Uri.parse(apiUrl + '/guest/search-article?page=${page}'),
          body: {'cari': keyword});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        for (Map<String, dynamic> item in data['data']['data_article']) {
          articleList.add(ArticleList.fromJson(item));
        }

        return articleList;
      } else {
        print('failed');
        throw Exception('failed');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20.0),
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
                    if (word.length >= 4) {
                      keyword = word;
                      articleList.clear();
                      setState(() {});
                    }
                  },
                )
              ],
            ),
          ),
          FutureBuilder(
              future: getListArtikel(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      controller: _listController,
                      itemCount: snapshot.data!.length ?? 0,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            try {
                              Provider.of<Article>(context, listen: false)
                                  .getDetailArtikel(
                                      context, snapshot.data![index].slug!);
                            } catch (err) {
                              print(err);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Material(
                              child: Material(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey[300]!, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl: snapshot.data![index]!.image!,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        },
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .title!,
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontFamily:
                                                                    "Sofia",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.schedule,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${DateTime.now().difference(DateTime.parse(snapshot.data![index].tanggal_publish!)).inHours} hours ago',
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Icon(
                                                      Icons.visibility,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${snapshot.data![index].jumlahView!} views',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
