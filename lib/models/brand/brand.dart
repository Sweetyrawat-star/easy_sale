class Brand {
  String id;
  String name;
  String logo;

  Brand({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
  );

}
