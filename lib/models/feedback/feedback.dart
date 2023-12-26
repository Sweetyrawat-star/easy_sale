class Feedback {
  String userId;
  String userName;
  String shopName;
  String shopAvatar;
  String id;
  String title;
  String content;
  int rating;

  Feedback({
    this.userId = "",
    this.userName = "",
    this.shopName = "",
    this.shopAvatar = "",
    this.id = "",
    this.title ="",
    this.content = "",
    this.rating = 0,
  });

  factory Feedback.fromMap(Map<String, dynamic> json) => Feedback(
        userId: json["user"]["id"],
        userName: json["user"]["fullname"],
        shopName: json["shop"]["name"],
        shopAvatar: json["shop"]["avatar"],
        id: json["id"],
        title: json["name"],
        content: json["desc"],
        rating: json["raiting"],
      );
  
}
