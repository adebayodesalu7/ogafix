import 'package:flutter_test/flutter_test.dart';
import 'package:ogafix/main.dart';

void main() {
  testWidgets('OgaFix splash and role test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OgaFixApp());

    // Verify splash screen displays OgaFix
    expect(find.text('OgaFix'), findsOneWidget);
  });
}
