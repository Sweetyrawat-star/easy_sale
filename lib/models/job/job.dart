class JobArea {
  String name;
  String type;
  JobArea({
    required this.name,
    required this.type,
  });

  factory JobArea.fromMap(Map<String, dynamic> json) {
    return JobArea(name: json["name"], type: json["type"]);
  }
}

class JobChannel {
  String name;
  String type;
  JobChannel({
    required this.name,
    required this.type,
  });

  factory JobChannel.fromMap(Map<String, dynamic> json) {
    return JobChannel(name: json["name"], type: json["type"]);
  }
}

class JobBrand {
  String name;
  JobBrand({
    required this.name,
  });
  factory JobBrand.fromMap(Map<String, dynamic> json) {
    return JobBrand(name: json["name"]);
  }
}

class JobProductChannel {
  JobChannel channel2;
  List<JobBrand> brands;
  JobProductChannel({
    required this.channel2,
    required this.brands,
  });

  factory JobProductChannel.fromMap(Map<String, dynamic> json) {
    return JobProductChannel(
      channel2: JobChannel.fromMap(json["channel_2"]),
      brands: List<JobBrand>.from(json["brand"].map((elem) => JobBrand.fromMap(elem))),
    );
  }
}

class MyJob {
  List<List<JobArea>> areas;
  JobChannel channel;
  JobChannel channel1;
  List<JobProductChannel> productChannel;

  MyJob(
      {required this.areas,
      required this.channel,
      required this.channel1,
      required this.productChannel});

  factory MyJob.fromMap(Map<String, dynamic> json) {
    return MyJob(
      areas: List.from(json["areas"].map((elem) => List<JobArea>.from(elem.map((el) => JobArea.fromMap(el))))),
      channel: JobChannel.fromMap(json["channel"]),
      channel1: JobChannel.fromMap(json["channel_1"]),
      productChannel: List<JobProductChannel>.from(json["product_channel"]
          .map((elem) => JobProductChannel.fromMap(elem))),
    );
  }
}
