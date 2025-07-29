class Report {
  final int? id;
  final String name;
  final String station;
  final String? workDescription;
  final String date;
  final double hours;
  final int? quantity;
  final String workEstimate;
  final String employee;
  final String? units;

  Report({
    this.id,
    required this.name,
    required this.station,
    this.workDescription,
    required this.date,
    required this.hours,
    this.quantity,
    required this.workEstimate,
    required this.employee,
    this.units,
  });

  // Convert a Report into a Map. The keys must correspond to the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'station': station,
      'workDescription': workDescription,
      'date': date,
      'hours': hours,
      'quantity': quantity,
      'workEstimate': workEstimate,
      'employee': employee,
      'units': units,
    };
  }

  // Convert a Map into a Report object.
  static Report fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      name: map['name'],
      station: map['station'],
      workDescription: map['workDescription'],
      date: map['date'],
      hours: map['hours'],
      quantity: map['quantity'],
      workEstimate: map['workEstimate'],
      employee: map['employee'],
      units: map['units'],
    );
  }
}
