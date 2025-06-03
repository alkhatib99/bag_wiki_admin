class SectionModel {
  int? id;
  String title;
  String content;
  String imageUrl;

  SectionModel({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
