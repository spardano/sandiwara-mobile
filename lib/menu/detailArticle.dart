import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class detailArticle extends StatefulWidget {
  const detailArticle({super.key, required String this.slug});

  final String slug;

  @override
  State<detailArticle> createState() => _detailArticleState();
}

class _detailArticleState extends State<detailArticle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.slug),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(widget.slug),
      ),
    );
  }
}
