import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physioghar_therapist/main.dart';
import 'package:physioghar_therapist/core/widgets/app_shell.dart';
import 'package:physioghar_therapist/features/home/presentation/home_screen.dart';
import 'package:physioghar_therapist/features/sessions/presentation/sessions_screen.dart';
import 'package:physioghar_therapist/features/sessions/providers/session_provider.dart';
import 'package:physioghar_therapist/features/profile/presentation/account_screen.dart';
import 'package:physioghar_therapist/features/schedule/domain/availability_slot.dart';
import 'package:physioghar_therapist/features/schedule/providers/schedule_provider.dart';

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();
}

class _FakeHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();
}

class _FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

// Transparent 1x1 pixel image data
final _transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('PhysioGhar app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PhysioGharApp()));
    expect(find.byType(AppShell), findsOneWidget);
  });

  testWidgets('sessions screen shows cancelled tab and tab state is complete', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SessionsScreen())),
    );

    expect(find.text('Cancelled'), findsOneWidget);
  });

  testWidgets('cancelling an upcoming reschedule closes without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SessionsScreen())),
    );

    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reschedule').first);
    await tester.pumpAndSettle();

    expect(find.text('Reschedule Session'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Reschedule Session'), findsNothing);
  });

  testWidgets('accepted card becomes a normal card after switching tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SessionsScreen())),
    );

    await tester.tap(find.text('Accept').first);
    await tester.pumpAndSettle();
    expect(find.text('JUST ACCEPTED'), findsOneWidget);

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();

    expect(find.text('JUST ACCEPTED'), findsNothing);
    expect(find.text('Reschedule'), findsAtLeastNWidgets(1));
  });

  testWidgets('account screen shows complete profile options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AccountScreen())),
    );

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Availability'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  test('reschedule updates the selected session state correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final original = container
        .read(sessionsProvider)
        .firstWhere((session) => session.id == 'up-1');

    expect(original.time, '10:00 AM');

    final updatedDate = DateTime(2026, 9, 15);
    container
        .read(sessionsProvider.notifier)
        .reschedule('up-1', updatedDate, '02:30 PM');

    final updated = container
        .read(sessionsProvider)
        .firstWhere((session) => session.id == 'up-1');

    expect(updated.date, updatedDate);
    expect(updated.time, '02:30 PM');

    final movedSlot = container
        .read(scheduleProvider)
        .firstWhere((slot) => slot.sessionId == 'up-1');
    expect(movedSlot.date, updatedDate);
    expect(movedSlot.time, '02:30 PM');
    expect(container.read(selectedScheduleDateProvider), updatedDate);
  });

  test('accepting one request only adds that session to upcoming', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(sessionsProvider.notifier).acceptRequest('req-1');

    final upcoming = container.read(upcomingSessionsProvider);
    final requests = container.read(requestSessionsProvider);

    expect(upcoming.map((session) => session.id), contains('req-1'));
    expect(upcoming.map((session) => session.id), isNot(contains('req-2')));
    expect(requests.map((session) => session.id), contains('req-2'));
    expect(requests.map((session) => session.id), isNot(contains('req-1')));

    final acceptedSlot = container
        .read(scheduleProvider)
        .firstWhere((slot) => slot.sessionId == 'req-1');
    expect(acceptedSlot.status, SlotStatus.booked);
    expect(acceptedSlot.patientName, 'Mina Gurung');
    expect(acceptedSlot.treatment, 'Shoulder Mobility');
    expect(container.read(selectedScheduleDateProvider), acceptedSlot.date);
  });

  testWidgets('accepted tomorrow session is shown as confirmed on home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionsProvider.overrideWith((ref) {
            final notifier = SessionNotifier();
            notifier.acceptRequest('req-1');
            return notifier;
          }),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('Confirmed'), findsAtLeastNWidgets(1));
  });

  testWidgets('home shows an empty state when tomorrow has no sessions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('No sessions tomorrow'), findsOneWidget);
  });
}
