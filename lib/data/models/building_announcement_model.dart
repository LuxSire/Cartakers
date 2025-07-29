class BuildingAnnoucemntModel {
  final String title;
  final int id;
  final String content;

  final String date;

  final String createdAt;

  BuildingAnnoucemntModel(
      {required this.title,
      required this.content,
      required this.date,
      required this.id,
      required this.createdAt});

  factory BuildingAnnoucemntModel.fromJson(Map<String, dynamic> json) {
    return BuildingAnnoucemntModel(
        title: json['title'],
        content: json['content'],
        date: json['date'],
        createdAt: json['created_at'] ?? DateTime.now(),
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date,
      'id': id,
      'created_at': createdAt
    };
  }
}
