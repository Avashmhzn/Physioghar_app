enum SessionStatus { request, upcoming, completed, cancelled }

class PhysioSession {
  const PhysioSession({
    required this.id,
    required this.patientName,
    required this.date,
    required this.time,
    required this.treatment,
    required this.location,
    required this.status,
    this.photoUrl,
    this.age,
    this.notes,
  });

  final String id;
  final String patientName;
  final DateTime date;
  final String time;
  final String treatment;
  final String location;
  final SessionStatus status;
  final String? photoUrl;
  final int? age;
  final String? notes;

  PhysioSession copyWith({
    String? patientName,
    DateTime? date,
    String? time,
    String? treatment,
    String? location,
    SessionStatus? status,
    String? photoUrl,
    int? age,
    String? notes,
  }) {
    return PhysioSession(
      id: id,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      time: time ?? this.time,
      treatment: treatment ?? this.treatment,
      location: location ?? this.location,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      notes: notes ?? this.notes,
    );
  }
}
