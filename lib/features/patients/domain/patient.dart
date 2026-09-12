class PatientNote {
  const PatientNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  PatientNote copyWith({
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return PatientNote(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Patient {
  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    required this.condition,
    required this.lastSessionDate,
    required this.treatmentHistory,
    required this.previousSessionInfo,
    required this.notes,
  });

  final String id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final String condition;
  final DateTime lastSessionDate;
  final List<String> treatmentHistory;
  final String previousSessionInfo;
  final List<PatientNote> notes;

  Patient copyWith({
    List<PatientNote>? notes,
  }) {
    return Patient(
      id: id,
      name: name,
      age: age,
      gender: gender,
      phone: phone,
      email: email,
      condition: condition,
      lastSessionDate: lastSessionDate,
      treatmentHistory: treatmentHistory,
      previousSessionInfo: previousSessionInfo,
      notes: notes ?? this.notes,
    );
  }
}
