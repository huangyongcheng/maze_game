import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_to_cisbox/domain/entities/direction.dart';
import 'package:home_to_cisbox/presentation/widgets/d_pad_controls.dart';

void main() {
  testWidgets('DPadControls emits correct direction on tap', (tester) async {
    final taps = <Direction>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: DPadControls(onMove: taps.add),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_drop_up));
    await tester.tap(find.byIcon(Icons.arrow_drop_down));
    await tester.tap(find.byIcon(Icons.arrow_left));
    await tester.tap(find.byIcon(Icons.arrow_right));
    await tester.pumpAndSettle();

    expect(taps, [
      Direction.north,
      Direction.south,
      Direction.west,
      Direction.east,
    ]);
  });

  testWidgets('DPadControls ignores taps when disabled', (tester) async {
    final taps = <Direction>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: DPadControls(enabled: false, onMove: taps.add),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_drop_up));
    await tester.pumpAndSettle();

    expect(taps, isEmpty);
  });
}
