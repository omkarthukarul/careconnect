import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:careconnect_maharashtra/main.dart';

void main() {
  testWidgets('App renders CareConnectApp with ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareConnectApp(),
      ),
    );

    // Initial splash frame pumps without exceptions
    expect(find.byType(CareConnectApp), findsOneWidget);
  });
}
