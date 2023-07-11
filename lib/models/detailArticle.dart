class detailArticle {
  detailArticle({
    this.id,
    this.slug,
    this.title,
    this.oriTitle,
    this.image,
    this.url,
    this.jumlahView,
    this.jumlahComments,
    this.category,
    this.author,
    this.tanggal_publish,
    this.content,
  });

  final String? id;
  final String? slug;
  final String? title;
  final String? oriTitle;
  final String? image;
  final String? url;
  final int? jumlahView;
  final int? jumlahComments;
  final String? category;
  final String? author;
  final String? tanggal_publish;
  final List<ContentArticle>? content;

  factory detailArticle.fromJson(Map<String, dynamic> json) => detailArticle(
      id: json["id"] == null ? null : json["id"].toString(),
      slug: json["slug"] == null ? null : json["slug"],
      title: json["title"] == null ? null : json["title"],
      oriTitle: json["oriTitle"] == null ? null : json["oriTitle"],
      image: json["image"] == null ? null : json["image"],
      url: json["url"] == null ? null : json["url"],
      jumlahView: json["jumlahView"] == null ? null : json["jumlahView"],
      jumlahComments:
          json["jumlahComments"] == null ? null : json["jumlahComments"],
      category: json["category"] == null ? null : json["category"],
      author: json["author"] == null ? null : json["author"],
      tanggal_publish: json["tanggal_publish"] == null ? null : json['tanggal_publish'],
      content: json["content"] == null
          ? null
          : List<ContentArticle>.from(
              json["content"].map((x) => ContentArticle.fromJson(x))));
}

class ContentArticle {
  ContentArticle({this.desc, this.other, this.slug});

  final String? desc;
  final String? other;
  final String? slug;

  factory ContentArticle.fromJson(Map<String, dynamic> json) => ContentArticle(
      desc: json["desc"] == null ? null : json["desc"].toString(),
      other: json["other"] == null ? null : json["other"].toString(),
      slug: json["slug"] == null ? null : json["slug"].toString());
}
