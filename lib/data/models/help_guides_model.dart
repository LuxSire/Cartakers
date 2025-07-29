class HelpGuidesModel {
  final String category;
  final List<GuideItem> guides;

  HelpGuidesModel({required this.category, required this.guides});

  // Convert JSON to Model
  factory HelpGuidesModel.fromJson(Map<String, dynamic> json) {
    return HelpGuidesModel(
      category: json['category'],
      guides: (json['guides'] as List)
          .map((item) => GuideItem.fromJson(item))
          .toList(),
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'guides': guides.map((item) => item.toJson()).toList(),
    };
  }
}

// **Guide Item Model (For Individual Guides)**
class GuideItem {
  final String category;
  final String title;
  final String content;

  GuideItem(
      {required this.category, required this.title, required this.content});

  // Convert JSON to GuideItem Model
  factory GuideItem.fromJson(Map<String, dynamic> json) {
    return GuideItem(
      category: json['category'],
      title: json['title'],
      content: json['content'],
    );
  }

  // Convert GuideItem Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'content': content,
    };
  }
}
