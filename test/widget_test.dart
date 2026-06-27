import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexmastery_mobile/app/bootstrap/lexmastery_app.dart';

void main() {
  testWidgets('Login screen renders for unauthenticated state',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LexMasteryApp()));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
