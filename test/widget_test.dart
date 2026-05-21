import 'package:flutter_test/flutter_test.dart';
import 'package:doingnow/homescreen.dart'; // Import your actual app code

void main() {
  testWidgets('App loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Replace 'HabitApp' with whatever your class name is in homescreen.dart
    await tester.pumpWidget(const HabitApp());

    // Verify that the app starts (you can change 'Today' to any text you have on your screen)
    expect(find.text('Today'), findsWidgets);
  });
}