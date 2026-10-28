import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sized_box_widget_presentation/main.dart';

void main() {
  testWidgets('Checkout pay button is full width and 52 tall', (tester) async {
    await tester.pumpWidget(const MyApp());

    final button = find.widgetWithText(FilledButton, 'Pay \$6.49');
    expect(button, findsOneWidget);

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final size = tester.getSize(button);
    // Full width minus the 16px padding on each side.
    expect(size.width, screenWidth - 32);
    expect(size.height, 52);
  });

  testWidgets('Quantity updates the total', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();

    expect(find.text('Pay \$10.99'), findsOneWidget);
  });

  testWidgets('Playground Defaults sets everything to null', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Playground'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Defaults'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('SizedBox(width: null, height: null, child: null)'),
      findsOneWidget,
    );
    expect(find.textContaining('rendered 0 × 0'), findsOneWidget);
  });
}
