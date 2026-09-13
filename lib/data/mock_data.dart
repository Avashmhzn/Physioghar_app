import '../features/patients/domain/patient.dart';
import '../features/profile/domain/therapist_profile.dart';
import '../features/schedule/domain/availability_slot.dart';
import '../features/sessions/domain/session.dart';

class MockData {
  static DateTime get today => DateTime.now();

  static TherapistProfile therapist = const TherapistProfile(
    name: 'Dr. Anjali Rai',
    email: 'anjali.rai@physioghar.com',
    phone: '+977 9841234567',
    experience: '8 years',
    specialization: 'Orthopedic & Sports Physiotherapy',
    address: 'Lalitpur, Nepal',
    profilePicUrl: 'https://i.pravatar.cc/150?img=32',
  );

  static List<PhysioSession> sessions = [
    PhysioSession(
      id: 'req-1',
      patientName: 'Mina Gurung',
      age: 36,
      date: today.add(const Duration(days: 1)),
      time: '11:00 AM',
      treatment: 'Shoulder Mobility',
      location: 'Home Visit',
      status: SessionStatus.request,
    ),
    PhysioSession(
      id: 'req-2',
      patientName: 'Bikash Shrestha',
      age: 50,
      date: today.add(const Duration(days: 2)),
      time: '04:00 PM',
      treatment: 'Post Stroke Rehab',
      location: 'Clinic',
      status: SessionStatus.request,
    ),
    PhysioSession(
      id: 'up-1',
      patientName: 'Sita Sharma',
      age: 42,
      date: today,
      time: '10:00 AM',
      treatment: 'Back Pain',
      location: 'Home Visit',
      status: SessionStatus.upcoming,
    ),
    PhysioSession(
      id: 'up-2',
      patientName: 'Ram Thapa',
      age: 58,
      date: today,
      time: '02:00 PM',
      treatment: 'Knee Rehabilitation',
      location: 'Clinic',
      status: SessionStatus.upcoming,
    ),
    PhysioSession(
      id: 'done-1',
      patientName: 'Nisha Karki',
      age: 29,
      date: today.subtract(const Duration(days: 2)),
      time: '01:00 PM',
      treatment: 'Neck Pain',
      location: 'Clinic',
      status: SessionStatus.completed,
      notes: 'Patient showed improved range of motion. Continue stretching routine.',
    ),
  ];

  static List<AvailabilitySlot> availabilitySlots() {
    final week = List.generate(7, (i) {
      final weekday = today.weekday - DateTime.monday;
      final monday = today.subtract(Duration(days: weekday));
      return monday.add(Duration(days: i));
    });

    final times = ['09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM'];
    final slots = <AvailabilitySlot>[];

    for (final day in week) {
      for (var i = 0; i < times.length; i++) {
        final isToday = day.year == today.year && day.month == today.month && day.day == today.day;
        SlotStatus status = SlotStatus.open;
        String? patient;
        String? treatment;
        String? location;

        if (isToday && times[i] == '10:00 AM') {
          status = SlotStatus.booked;
          patient = 'Sita Sharma';
          treatment = 'Back Pain';
          location = 'Home Visit';
        } else if (isToday && times[i] == '02:00 PM') {
          status = SlotStatus.booked;
          patient = 'Ram Thapa';
          treatment = 'Knee Rehabilitation';
          location = 'Clinic';
        } else if (i == 3 || i == 4) {
          status = SlotStatus.blocked;
        }

        slots.add(AvailabilitySlot(
          id: '${day.toIso8601String()}-${times[i]}',
          date: day,
          time: times[i],
          status: status,
          patientName: patient,
          treatment: treatment,
          location: location,
        ));
      }
    }

    return slots;
  }

  static List<Patient> patients = [
    Patient(
      id: 'p1',
      name: 'Sita Sharma',
      age: 42,
      gender: 'Female',
      phone: '+977 9800001111',
      email: 'sita.sharma@example.com',
      condition: 'Lower Back Pain',
      lastSessionDate: DateTime(2026, 9, 10),
      treatmentHistory: const ['Initial assessment', 'Core strengthening', 'Posture correction'],
      previousSessionInfo: 'Pain reduced from 7/10 to 4/10 after guided mobility work.',
      notes: [
        PatientNote(
          id: 'n1',
          title: 'Session Note',
          content: 'Patient reported reduced pain compared to previous session.\n\nExercise:\n- Knee flexion\n- Stretching\n- Strengthening\n\nNext Session:\nContinue strengthening exercises.',
          createdAt: DateTime(2026, 9, 10),
        ),
      ],
    ),
    Patient(
      id: 'p2',
      name: 'Ram Thapa',
      age: 58,
      gender: 'Male',
      phone: '+977 9800002222',
      email: 'ram.thapa@example.com',
      condition: 'Knee Rehabilitation',
      lastSessionDate: DateTime(2026, 9, 9),
      treatmentHistory: const ['Knee ROM', 'Balance drills', 'Gait training'],
      previousSessionInfo: 'Walking tolerance improved. Mild swelling remains.',
      notes: const [],
    ),
    Patient(
      id: 'p3',
      name: 'Nisha Karki',
      age: 29,
      gender: 'Female',
      phone: '+977 9800003333',
      email: 'nisha.karki@example.com',
      condition: 'Neck Pain',
      lastSessionDate: DateTime(2026, 9, 8),
      treatmentHistory: const ['Manual therapy', 'Mobility exercise'],
      previousSessionInfo: 'Reduced stiffness after treatment.',
      notes: const [],
    ),
  ];
}
