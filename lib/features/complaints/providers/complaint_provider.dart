import 'package:flutter_riverpod/legacy.dart';
import 'package:physioghar_therapist/features/complaints/domain/complaint.dart';

class ComplaintNotifier extends StateNotifier<List<Complaint>> {
  ComplaintNotifier() : super([]);

  void addComplaint({
    required String category,
    required String subject,
    required String description,
  }) {
    final complaint = Complaint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: category,
      subject: subject,
      description: description,
      createdAt: DateTime.now(),
    );
    state = [...state, complaint];
  }
}

final complaintsProvider =
    StateNotifierProvider<ComplaintNotifier, List<Complaint>>(
      (ref) => ComplaintNotifier(),
    );
