import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sandiwara/models/News.dart';

class searchBerita extends StatefulWidget {
  const searchBerita({super.key});

  @override
  State<searchBerita> createState() => _searchBeritaState();
}

class _searchBeritaState extends State<searchBerita> {
  final newsItem = <News>[
    News(
        id: 231,
        category: "Sporth",
        imagePath:
            "https://images.pexels.com/photos/5837131/pexels-photo-5837131.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
        title: "Basketball new team",
        content:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"),
    News(
        id: 2313,
        category: "Politic",
        imagePath:
            "https://images.pexels.com/photos/4560088/pexels-photo-4560088.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
        title: "United States Public new president",
        content:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"),
    News(
        id: 231,
        category: "Tech",
        imagePath:
            "https://images.pexels.com/photos/3861964/pexels-photo-3861964.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
        title: "New framework flutter",
        content:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _TemukanBerita(),
        ],
      ),
    );
  }
}

class _TemukanBerita extends StatelessWidget {
  const _TemukanBerita({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          )
        ],
      ),
    );
  }
}
