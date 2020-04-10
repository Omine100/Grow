class Plant {
  String type;
  String name;
  String birthdate;
  String imageURL;

  Plant(
      this.type,
      this.name,
      this.imageURL,
      this.birthdate,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    'imageURL': imageURL,
    'birthdate': birthdate,
  };
}