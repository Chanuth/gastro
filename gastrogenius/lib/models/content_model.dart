class ContentModel {
  final String title;
  final String image_name;
  bool isFavorite;

  ContentModel({
    required this.title,
    required this.image_name,
    this.isFavorite = false,
  });

  factory ContentModel.fromMap(Map<String, dynamic> parsedJson) {
    return ContentModel(
      title: parsedJson["title"],
      image_name: parsedJson["image_name"],
    );
  }
}
