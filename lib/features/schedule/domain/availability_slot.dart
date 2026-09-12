enum SlotStatus { open, booked, blocked }

class AvailabilitySlot {
  const AvailabilitySlot({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    this.patientName,
    this.treatment,
    this.location,
  });

  final String id;
  final DateTime date;
  final String time;
  final SlotStatus status;
  final String? patientName;
  final String? treatment;
  final String? location;

  AvailabilitySlot copyWith({
    DateTime? date,
    String? time,
    SlotStatus? status,
    String? patientName,
    String? treatment,
    String? location,
  }) {
    return AvailabilitySlot(
      id: id,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
      treatment: treatment ?? this.treatment,
      location: location ?? this.location,
    );
  }
}
