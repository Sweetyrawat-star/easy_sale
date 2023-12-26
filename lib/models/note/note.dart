class Note {
  String id;
  String? title;
  String content;
  int createdAt;

  Note({
    this.id = "",
    this.title = "",
    this.content = "",
    this.createdAt = 0,
  });

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json["id"],
    title: json["name"],
    content: json["content"],
    createdAt: json["created_at"]*1000000,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "content": content,
  };
  
}
