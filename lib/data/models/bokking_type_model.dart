class BookingTypeModel {
  final int id;
  final String name;
  final String? description;

  BookingTypeModel({
    required this.id,
    required this.name,
    this.description,
  });

  // Factory method to create a RequestTypeModel from JSON
  factory BookingTypeModel.fromJson(Map<String, dynamic> json) {
    return BookingTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '', // Handle null description
    );
  }
}
