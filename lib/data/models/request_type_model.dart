class RequestTypeModel {
  final int id;
  final String name;
  final String? description;

  RequestTypeModel({
    required this.id,
    required this.name,
    this.description,
  });

  // Factory method to create a RequestTypeModel from JSON
  factory RequestTypeModel.fromJson(Map<String, dynamic> json) {
    return RequestTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '', // Handle null description
    );
  }
}
