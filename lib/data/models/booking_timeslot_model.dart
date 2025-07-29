class BookingTimeslotModel {
  final String slotTime;
  final int status;

  BookingTimeslotModel({
    required this.slotTime,
    required this.status,
  });

  factory BookingTimeslotModel.fromJson(Map<String, dynamic> json) {
    return BookingTimeslotModel(
      slotTime: json['slot_time'],
      status: json['status'],
    );
  }
}
