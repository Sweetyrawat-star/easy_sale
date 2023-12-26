class User {
  String? userId;
  String? fullName;
  String? phone;
  String? email;
  String? avatar;
  String token;
  String freshToken;
  bool jobRegistered;

  User({
    this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.avatar,
    this.token = "",
    this.freshToken = "",
    this.jobRegistered = false
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        userId: json["user"]["id"],
        fullName: json["user"]["fullname"],
        phone: json["user"]["phone"],
        email: json["user"]["email"],
        avatar: json["user"]["avatar"],
        token: json["token"],
        freshToken: json["refresh_token"],
        jobRegistered: json["user"]["job_registered"] ?? false,
      );

  factory User.fromMap2(Map<String, dynamic> json) => User(
    userId: json["id"],
    fullName: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    avatar: json["avatar"],
    jobRegistered: json["job_registered"],
  );

  factory User.fromLocal(Map<String, dynamic> json) => User(
    userId: json["id"],
    fullName: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    avatar: json["avatar"],
    jobRegistered: json["job_registered"],
  );

  Map<String, dynamic> toMap() => {
        "id": this.userId,
        "fullname": this.fullName,
        "phone": this.phone,
        "email": this.email,
        "avatar": this.avatar,
        "job_registered": this.jobRegistered,
      };
}
