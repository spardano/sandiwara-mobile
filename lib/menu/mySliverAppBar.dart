import 'package:flutter/material.dart';
import 'package:sandiwara/widgets/customTag.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String? img, id, title, category, author;

  MySliverAppBar(
      {required this.expandedHeight,
      this.img,
      this.id,
      this.title,
      this.category,
      this.author});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: const Color(0xFF172E4D),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            transitionOnUserGestures: true,
            tag: 'hero-tag-$id',
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.red[600],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(img!),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 130.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: <Color>[
                      Color(0xFF000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: CustomTag(
                    backgroundColor: Colors.grey.withAlpha(150),
                    children: [
                      Text(
                        category!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(
                      title!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    author!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontFamily: "Popins",
                        fontWeight: FontWeight.w400),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 15.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 36.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
