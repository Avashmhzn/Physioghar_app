import 'package:flutter_riverpod/legacy.dart';

class AvailabilityNotifier extends StateNotifier<bool> {
  AvailabilityNotifier() : super(true);

  void toggle() => state = !state;
  void setAvailability(bool value) => state = value;
}

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, bool>((ref) {
  return AvailabilityNotifier();
});
