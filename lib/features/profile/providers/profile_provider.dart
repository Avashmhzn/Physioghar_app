import 'package:flutter_riverpod/legacy.dart';
import 'package:physioghar_therapist/data/mock_data.dart';
import 'package:physioghar_therapist/features/profile/domain/therapist_profile.dart';


class TherapistProfileNotifier extends StateNotifier<TherapistProfile> {
  TherapistProfileNotifier() : super(MockData.therapist);

  void updateProfile(TherapistProfile profile) {
    state = profile;
  }
}

final therapistProfileProvider = StateNotifierProvider<TherapistProfileNotifier, TherapistProfile>((ref) {
  return TherapistProfileNotifier();
});
