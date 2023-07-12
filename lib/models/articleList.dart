class ArticleList {
  ArticleList({
    this.id,
    this.slug,
    this.image,
    this.title,
    this.category,
    this.jumlahView,
    this.tanggal_publish,
    this.author,
  });

  final int? id;
  final String? slug;
  final String? image;
  final String? title;
  final String? category;
  final int? jumlahView;
  final String? tanggal_publish;
  final String? author;

  factory ArticleList.fromJson(Map<String, dynamic> json) => ArticleList(
      id: json["id"] == null ? null : json["id"],
      slug: json["slug"] == null ? null : json["slug"],
      title: json["title"] == null ? null : json["title"],
      image: json["image"] == null ? null : json["image"],
      category: json["category"] == null ? null : json["category"],
      jumlahView: json["jumlahView"] == null ? null : json["jumlahView"],
      author: json["author"] == null ? null : json["author"],
      tanggal_publish:
          json["tanggal_publish"] == null ? null : json['tanggal_publish']);

  static List<ArticleList> fromJsonList(dynamic jsonList) {
    final articles = <ArticleList>[];
    if (jsonList == null) return articles;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        articles.add(
          ArticleList.fromJson(json),
        );
      }
    }

    return articles;
  }
}
