class commentArticle {
  commentArticle({
    this.id,
    this.id_user,
    this.nama_user,
    this.message,
    this.balasan,
    this.tanggal_balas,
    this.tanggal_comment,
  });

  final int? id;
  final int? id_user;
  final String? nama_user;
  final String? message;
  final String? balasan;
  final String? tanggal_balas;
  final String? tanggal_comment;

  factory commentArticle.fromJson(Map<String, dynamic> json) => commentArticle(
      id: json["id"] == null ? null : json["id"],
      id_user: json["id_user"] == null ? null : json["id_user"],
      nama_user: json["nama_user"] == null ? null : json["nama_user"],
      message: json["message"] == null ? null : json["message"],
      balasan: json["balasan"] == null ? null : json["balasan"],
      tanggal_balas:
          json["tanggal_balas"] == null ? null : json["tanggal_balas"],
      tanggal_comment:
          json["tanggal_comment"] == null ? null : json["tanggal_comment"]);
}
