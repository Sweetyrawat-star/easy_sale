class Provider {
  String id;
  String name;
  String logo;

  Provider({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Provider.fromMap(Map<String, dynamic> json) => Provider(
    id: json["id"],
    name: json["name"],
    logo: json["logo"] ?? "",
  );

}
