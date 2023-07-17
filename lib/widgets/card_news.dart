import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwara/providers/article.dart';
import 'package:sandiwara/utils/helpers.dart';
import 'package:sandiwara/widgets/card_title.dart';
import 'package:sandiwara/widgets/image_news.dart';

class CardNews extends StatelessWidget {
  const CardNews(
      {Key? key,
      required this.slug,
      required this.image,
      required this.title,
      required this.jumlahView,
      required this.tanggalPublish})
      : super(key: key);
  final String slug;
  final String image;
  final String title;
  final String jumlahView;
  final String tanggalPublish;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          Provider.of<Article>(context, listen: false)
              .getDetailArtikel(context, slug);
        } catch (err) {
          Helpers().showScafoldMessage(context, err.toString());
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Material(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!, width: 1.0),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: <Widget>[
                ImageNews(
                  image: image,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CardTitle(
                            title: title,
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
                                '${DateTime.now().difference(DateTime.parse(tanggalPublish)).inHours} hours ago',
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
                                '$jumlahView views',
                                style: const TextStyle(fontSize: 12),
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
    );
  }
}
