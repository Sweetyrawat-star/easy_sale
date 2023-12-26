class Routing {
  String id;
  String title;
  int createdAt;

  Routing({
    this.id = "",
    this.title = "",
    this.createdAt = 0,
  });

  factory Routing.fromMap(Map<String, dynamic> json) => Routing(
    id: json["id"],
    title: json["name"],
    createdAt: json["created_at"]*1000000,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
  };
  
}
