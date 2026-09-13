import 'package:flutter_riverpod/legacy.dart';

class AvailabilityNotifier extends StateNotifier<bool> {
  AvailabilityNotifier() : super(true);

  void toggle() => state = !state;
  void setAvailability(bool value) => state = value;
}

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, bool>((ref) {
  return AvailabilityNotifier();
});

class HomeVisitsNotifier extends StateNotifier<bool> {
  HomeVisitsNotifier() : super(true);

  void toggle() => state = !state;
  void setHomeVisits(bool value) => state = value;
}

final homeVisitsProvider = StateNotifierProvider<HomeVisitsNotifier, bool>((ref) {
  return HomeVisitsNotifier();
});
