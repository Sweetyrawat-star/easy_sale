class Rating {
  String comment;
  int star;
  String storeId;
  String? storeName;
  String? storeAvatar;
  String? userId;
  String? userName;
  String? userAvatar;
  int? createdAt;

  Rating({
    required this.comment,
    required this.star,
    required this.storeId,
    this.storeName,
    this.storeAvatar,
    this.userId,
    this.userName,
    this.userAvatar,
    this.createdAt,
  });

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        comment: json["comment"],
        star: json["star"],
        storeId: json["shop_id"],
        storeName: json["shop_name"],
        storeAvatar: json["shop_avatar"],
        userId: json["rater_id"],
        userName: json["rater_name"],
        userAvatar: json["rater_avatar"],
        createdAt: json["created_at"] * 1000000,
      );

  Map<String, dynamic> toMap() => {
        "comment": comment,
        "star": star,
        "shop_id": storeId,
      };
}
