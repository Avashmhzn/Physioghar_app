import 'package:flutter_riverpod/legacy.dart';
import '../../../data/mock_data.dart';
import '../domain/therapist_profile.dart';

class TherapistProfileNotifier extends StateNotifier<TherapistProfile> {
  TherapistProfileNotifier() : super(MockData.therapist);

  void updateProfile(TherapistProfile profile) {
    state = profile;
  }
}

final therapistProfileProvider = StateNotifierProvider<TherapistProfileNotifier, TherapistProfile>((ref) {
  return TherapistProfileNotifier();
});
