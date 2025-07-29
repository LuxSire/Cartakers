class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  // Convert JSON response to CategoryModel
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0, // Default to 0 if null
      name: json['name'] ?? "Unknown", // Default to "Unknown"
    );
  }
  // Convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
