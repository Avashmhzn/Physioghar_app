import 'package:flutter_test/flutter_test.dart';

import 'package:physioghar_therapist/main.dart';

void main() {
  testWidgets('PhysioGhar app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PhysioGharApp());

    // Verify that the app loads
    expect(find.byType(AppShell), findsOneWidget);
  });
}
